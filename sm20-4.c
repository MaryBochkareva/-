#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <string.h>
#include <sys/wait.h>



volatile int flag;


void
handler(int signum)
{
    flag = 1;
}


void
term_f(FILE *r, FILE *w, int fd)
{
    fclose(r);
    fclose(w);
    close(fd);
    exit(0);
}


int
main(int argc, char *argv[])
{
    struct sigaction term_sa = {};
    term_sa.sa_handler = handler;
    term_sa.sa_flags = 0;
    sigaction(SIGTERM, &term_sa, NULL);

    struct addrinfo *info, hints = {};
    hints.ai_family = AF_INET;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_flags = AI_PASSIVE;
    hints.ai_protocol = IPPROTO_TCP;
    getaddrinfo(NULL, argv[1], &hints, &info);

    int sfd = socket(info->ai_family, info->ai_socktype, info->ai_protocol);
    int true_val = 1;
    setsockopt(sfd, SOL_SOCKET, SO_REUSEADDR, &true_val, sizeof(true_val));
    setsockopt(sfd, SOL_SOCKET, SO_REUSEPORT, &true_val, sizeof(true_val));
    bind(sfd, info->ai_addr, info->ai_addrlen);
    listen(sfd, 5);

    struct sockaddr_storage addr;
    socklen_t addrlen = sizeof(addr);

    for (int i = 1;;++i) {
        while (waitpid(-1, NULL, WNOHANG) > 0);
        if (flag) {
            close(sfd);
            kill(0, SIGTERM);
            while (wait(NULL) != -1);
            freeaddrinfo(info);
            return 0;
        }
        int new_fd = accept(sfd, (struct sockaddr *) &addr, &addrlen);
        if (new_fd == -1) {
            --i;
            continue;
        }
        if (!fork()) {
            int max, num, sum, ret;
            int cpr = dup(new_fd);
            int cpw = dup(new_fd);
            FILE *read = fdopen(cpr, "r");
            FILE *write = fdopen(cpw, "w");
            ret = fprintf(write, "%s\r\n", argv[2]);
            if (ret <= 0) {
                term_f(read, write, new_fd);
            }
            fflush(write);
            ret = fprintf(write, "%d\r\n", i);
            if (ret <= 0 || flag) {
                term_f(read, write, new_fd);
            }
            fflush(write);
            if (flag) {
                term_f(read, write, new_fd);
            }
            ret = fscanf(read, "%d", &max);
            if (ret <= 0 || flag) {
                term_f(read, write, new_fd);
            }
            ret = fprintf(write, "%d\r\n", max);
            if (ret <= 0 || flag) {
                term_f(read, write, new_fd);
            }
            fflush(write);
            for (;;) {
                ret = fscanf(read, "%d", &num);
                if (ret <= 0 || flag) {
                    term_f(read, write, new_fd);
                }
                if (num > max || __builtin_sadd_overflow(num, i, &sum)) {
                    ret = fprintf(write, "%d\r\n", -1);
                    if (ret > 0) {
                        fflush(write);
                    }
                    term_f(read, write, new_fd);
                } else {
                    ret = fprintf(write, "%d\r\n", sum);
                    if (ret <= 0 || flag) {
                        term_f(read, write, new_fd);
                    }
                    fflush(write);
                }
            }
        }
        close(new_fd);
    }
    return 0;
}
