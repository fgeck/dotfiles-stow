#include "../sketchybar.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>

#define BUFFER_SIZE 4096
#define RECONNECT_DELAY 1

static int connect_to_kanata(const char* host, int port) {
  int sock = socket(AF_INET, SOCK_STREAM, 0);
  if (sock < 0) return -1;

  struct hostent* server = gethostbyname(host);
  if (!server) {
    close(sock);
    return -1;
  }

  struct sockaddr_in addr;
  memset(&addr, 0, sizeof(addr));
  addr.sin_family = AF_INET;
  memcpy(&addr.sin_addr.s_addr, server->h_addr, server->h_length);
  addr.sin_port = htons(port);

  if (connect(sock, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
    close(sock);
    return -1;
  }

  return sock;
}

// Simple JSON value extraction - finds "key":"value" and returns value
static bool extract_json_value(const char* json, const char* key, char* out, size_t out_size) {
  char search[128];
  snprintf(search, sizeof(search), "\"%s\":\"", key);

  const char* start = strstr(json, search);
  if (!start) return false;

  start += strlen(search);
  const char* end = strchr(start, '"');
  if (!end) return false;

  size_t len = end - start;
  if (len >= out_size) len = out_size - 1;

  strncpy(out, start, len);
  out[len] = '\0';
  return true;
}

// Extract value from array format: "key":["value"]
static bool extract_json_array_value(const char* json, const char* key, char* out, size_t out_size) {
  char search[128];
  snprintf(search, sizeof(search), "\"%s\":[\"", key);

  const char* start = strstr(json, search);
  if (!start) return false;

  start += strlen(search);
  const char* end = strchr(start, '"');
  if (!end) return false;

  size_t len = end - start;
  if (len >= out_size) len = out_size - 1;

  strncpy(out, start, len);
  out[len] = '\0';
  return true;
}

static void handle_message(const char* msg) {
  char trigger[512];
  char value[128];

  // Handle LayerChange: {"LayerChange":{"new":"nav"}}
  if (strstr(msg, "\"LayerChange\"")) {
    if (extract_json_value(msg, "new", value, sizeof(value))) {
      snprintf(trigger, sizeof(trigger), "--trigger kbd_layer LAYER='%s'", value);
      sketchybar(trigger);
    }
    return;
  }

  // Handle MessagePush: {"MessagePush":{"message":["mod:cmd:on"]}}
  if (strstr(msg, "\"MessagePush\"")) {
    if (extract_json_array_value(msg, "message", value, sizeof(value))) {
      // Parse "mod:name:state" format
      char mod[32], state[8];
      if (sscanf(value, "mod:%31[^:]:%7s", mod, state) == 2) {
        snprintf(trigger, sizeof(trigger), "--trigger kbd_mod MOD='%s' STATE='%s'", mod, state);
        sketchybar(trigger);
      }
    }
    return;
  }
}

static void process_buffer(char* buffer, size_t* len) {
  // Process complete JSON messages (newline-delimited)
  char* line_start = buffer;
  char* newline;

  while ((newline = strchr(line_start, '\n')) != NULL) {
    *newline = '\0';
    if (strlen(line_start) > 0) {
      handle_message(line_start);
    }
    line_start = newline + 1;
  }

  // Move incomplete data to beginning of buffer
  size_t remaining = strlen(line_start);
  if (remaining > 0 && line_start != buffer) {
    memmove(buffer, line_start, remaining);
  }
  *len = remaining;
}

int main(int argc, char** argv) {
  if (argc < 3) {
    printf("Usage: %s <host> <port>\n", argv[0]);
    printf("Example: %s localhost 7070\n", argv[0]);
    exit(1);
  }

  const char* host = argv[1];
  int port = atoi(argv[2]);

  // Register events with sketchybar
  sketchybar("--add event kbd_layer");
  sketchybar("--add event kbd_mod");

  char buffer[BUFFER_SIZE];
  size_t buffer_len = 0;

  for (;;) {
    int sock = connect_to_kanata(host, port);
    if (sock < 0) {
      sleep(RECONNECT_DELAY);
      continue;
    }

    buffer_len = 0;
    ssize_t bytes;
    while ((bytes = read(sock, buffer + buffer_len, BUFFER_SIZE - buffer_len - 1)) > 0) {
      buffer_len += bytes;
      buffer[buffer_len] = '\0';
      process_buffer(buffer, &buffer_len);
    }

    close(sock);
    sleep(RECONNECT_DELAY);
  }

  return 0;
}
