# Exercise 2: Linux System Report Container

## Overview

This project demonstrates how to create a lightweight Docker container that generates a basic Linux system report using a shell script.

The project demonstrates:

* Linux shell scripting
* Standard Linux system commands
* File permissions
* Docker image creation
* Docker container execution
* Docker CLI inspection
* Container logs and status
* Passing command-line arguments to a containerized shell script

---

## Objectives

The objective of this exercise is to:

1. Create a Linux system-report shell script.
2. Collect system information using standard Linux commands.
3. Test the script directly before containerization.
4. Package the script into a Docker image.
5. Run the report inside a Docker container.
6. View container status and logs.
7. Inspect the Docker container configuration.
8. Pass a server name as a command-line argument to the containerized script.

---

## Project Structure

```text
system-report/
├── Dockerfile
├── report.sh
└── README.md
```

---

## 1. Shell Script

The `report.sh` script generates a formatted Linux system report.

The script collects:

| Information               | Linux Command                      |
| ------------------------- | ---------------------------------- |
| Server name               | Command-line argument / `hostname` |
| Hostname                  | `hostname`                         |
| Current date              | `date`                             |
| Current user              | `whoami`                           |
| Operating system / kernel | `uname -a`                         |
| Disk usage                | `df -h`                            |
| Memory information        | `free -h`                          |
| Running processes         | `ps aux`                           |

### Script

```bash
#!/bin/sh

SERVER_NAME="${1:-$(hostname)}"

echo "=========================================="
echo "         LINUX SYSTEM REPORT"
echo "=========================================="

echo
echo "Server Name"
echo "------------------------------------------"
echo "$SERVER_NAME"

echo
echo "Hostname"
echo "------------------------------------------"
hostname

echo
echo "Current Date"
echo "------------------------------------------"
date

echo
echo "Current User"
echo "------------------------------------------"
whoami

echo
echo "Operating System / Kernel"
echo "------------------------------------------"
uname -a

echo
echo "Disk Usage"
echo "------------------------------------------"
df -h

echo
echo "Memory Information"
echo "------------------------------------------"
free -h

echo
echo "Running Processes"
echo "------------------------------------------"
ps aux

echo
echo "=========================================="
echo "         END OF SYSTEM REPORT"
echo "=========================================="
```

---

## 2. Direct Linux Script Execution

Execute permission was granted using:

```bash
chmod +x report.sh
```

Permission was verified using:

```bash
ls -l report.sh
```

The script was tested directly before containerization:

```bash
./report.sh SERVER-01
```

The generated report included:

```text
Server Name
------------------------------------------
SERVER-01
```

This confirms that the shell script works correctly before being packaged into Docker.

---

## 3. Dockerfile

The Docker image uses Alpine Linux as the lightweight base image.

```dockerfile
FROM alpine:latest

WORKDIR /app

COPY report.sh .

RUN chmod +x report.sh

ENTRYPOINT ["./report.sh"]
```

### Dockerfile Explanation

#### Base Image

```dockerfile
FROM alpine:latest
```

Uses Alpine Linux as a lightweight Linux base image.

#### Working Directory

```dockerfile
WORKDIR /app
```

Sets `/app` as the working directory inside the container.

#### Copy Script

```dockerfile
COPY report.sh .
```

Copies the shell script into the `/app` directory inside the image.

#### Execute Permission

```dockerfile
RUN chmod +x report.sh
```

Ensures that the shell script is executable inside the container.

#### Startup Command

```dockerfile
ENTRYPOINT ["./report.sh"]
```

Configures `report.sh` as the container's main executable.

Using `ENTRYPOINT` allows additional command-line arguments to be passed directly to the script.

For example:

```bash
docker run system-report:v1 SERVER-01
```

is executed inside the container effectively as:

```bash
./report.sh SERVER-01
```

---

## 4. Docker Image Build

The image was built using the required tag:

```bash
docker build -t system-report:v1 .
```

The image can be verified using:

```bash
docker image ls system-report
```

Expected image:

```text
REPOSITORY      TAG
system-report   v1
```

---

## 5. Run the Container

The container was executed with a server name:

```bash
docker run --name system-report-server01 system-report:v1 SERVER-01
```

The container generated the Linux system report successfully.

The report included:

```text
==========================================
         LINUX SYSTEM REPORT
==========================================

Server Name
------------------------------------------
SERVER-01

Hostname
------------------------------------------
...

Current Date
------------------------------------------
...

Current User
------------------------------------------
...

Operating System / Kernel
------------------------------------------
...

Disk Usage
------------------------------------------
...

Memory Information
------------------------------------------
...

Running Processes
------------------------------------------
...

==========================================
         END OF SYSTEM REPORT
==========================================
```

---

## 6. Container Status

The container status was checked using:

```bash
docker ps -a
```

Since the report is a short-lived process, the container exits after generating the report.

Expected successful status:

```text
Exited (0)
```

`Exited (0)` indicates that the application completed successfully.

---

## 7. Container Logs

The generated report can be viewed again using:

```bash
docker logs system-report-server01
```

The logs contain the complete Linux system report.

The server name can be verified in the logs:

```text
Server Name
------------------------------------------
SERVER-01
```

---

## 8. Container Inspection

The Docker container startup configuration was inspected using:

```bash
docker inspect --format='{{.Config.Cmd}}' system-report-server01
```

The container startup configuration uses:

```text
./report.sh
```

The actual executable and argument passed to the container can be inspected using:

```bash
docker inspect --format='Path={{.Path}} Args={{json .Args}}' system-report-server01
```

Expected result:

```text
Path=./report.sh Args=["SERVER-01"]
```

This confirms that:

* `./report.sh` is the container entrypoint.
* `SERVER-01` was passed as a command-line argument.

---

## 9. Exit Code Verification

The container exit code can be checked using:

```bash
docker inspect --format='ExitCode={{.State.ExitCode}}' system-report-server01
```

Expected result:

```text
ExitCode=0
```

An exit code of `0` indicates successful execution.

---

## 10. Additional Challenge

The script accepts a server name as its first command-line argument.

### Direct Linux Execution

```bash
./report.sh SERVER-01
```

Output:

```text
Server Name
------------------------------------------
SERVER-01
```

Another server name can also be supplied:

```bash
./report.sh WEB-SERVER-01
```

The report will display:

```text
Server Name
------------------------------------------
WEB-SERVER-01
```

### Docker Execution

The server name can be passed to the container:

```bash
docker run --name system-report-server01 system-report:v1 SERVER-01
```

Because the Dockerfile uses:

```dockerfile
ENTRYPOINT ["./report.sh"]
```

Docker passes `SERVER-01` as the first argument to the shell script.

Therefore:

```text
docker run system-report:v1 SERVER-01
```

effectively runs:

```text
./report.sh SERVER-01
```

inside the container.

---

## 11. Default Server Name

If no server name is supplied:

```bash
./report.sh
```

the script automatically uses the system hostname:

```bash
SERVER_NAME="${1:-$(hostname)}"
```

The same behavior works inside Docker:

```bash
docker run --name system-report-default system-report:v1
```

---

## 12. Evidence Commands

The following commands were used as evidence for the exercise.

### Project Files

```bash
pwd
ls -la
```

### Shell Script

```bash
cat report.sh
```

### Execute Permission

```bash
chmod +x report.sh
ls -l report.sh
```

### Direct Execution

```bash
./report.sh SERVER-01
```

### Dockerfile

```bash
cat Dockerfile
```

### Docker Image Build

```bash
docker build -t system-report:v1 .
```

### Docker Image Verification

```bash
docker image ls system-report
```

### Container Execution

```bash
docker run --name system-report-server01 system-report:v1 SERVER-01
```

### Container Status

```bash
docker ps -a
```

### Container Logs

```bash
docker logs system-report-server01
```

### Container Startup Command

```bash
docker inspect --format='{{.Config.Cmd}}' system-report-server01
```

### Executable and Arguments

```bash
docker inspect --format='Path={{.Path}} Args={{json .Args}}' system-report-server01
```

### Exit Code

```bash
docker inspect --format='ExitCode={{.State.ExitCode}}' system-report-server01
```

---

## 13. Result

The exercise was successfully completed.

### Deliverables

* `system-report/report.sh`
* `system-report/Dockerfile`
* `system-report/README.md`
* Docker image: `system-report:v1`
* Successful Linux system report generation
* Successful Docker container execution
* Container status and log verification
* Container inspection
* Command-line server-name argument support

---

## Skills Demonstrated

* Linux shell scripting
* Linux system administration commands
* File permissions
* Dockerfile creation
* Docker image building
* Docker container execution
* Docker CLI
* Container logs
* Container inspection
* Docker `ENTRYPOINT`
* Command-line arguments
* Basic container troubleshooting
