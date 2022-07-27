#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <assert.h>

int main(int argc, char** argv) {
  // Print the iconic serial greeting
  // TODO(cleanbaja): stop assuming that we're running on ttyS0
  printf("\nCrecentOS ninex-%s (%s)\n\n", getenv("NINEX_VERSION"), "ttyS0");

  // Set important enviorment variables
  setenv("HOME", "/", 0);
  setenv("PATH", "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin", 0);
  setenv("TERM", "linux", 0);

  // Now that the enviorment is fixed up, try to launch dash
  int dash_pid = fork();
  if (!dash_pid) {
    execl("/bin/dash", "/bin/dash", NULL);
  } else { assert(dash_pid != -1); }

  // Exit for now, until waitpid works upstream in the kernel
  return 0;
}
