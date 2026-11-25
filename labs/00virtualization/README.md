# Virtualization & Containerization - Cyber Lab S617

Build it, break it, defend it. A hands-on workshop where you stand up your own
virtual lab with one command, build and run containers with Docker, deploy a
real **Minecraft server** with Docker Compose, **perform a real container escape
and then fix it**, and learn how these systems are attacked and defended -
finishing with a project for your **GitHub portfolio**.

Part of the **Cybersecurity Lab Room S617** portfolio series.

---

## Start here

Work through the files in order:

1. **[SETUP.md](SETUP.md)** - install VirtualBox + Vagrant and bring up the
   workshop VM. **Do this first.**
2. **[00-foundations-virtualization-and-vagrant.md](00-foundations-virtualization-and-vagrant.md)**
   - what virtualization and Vagrant are, how to run any future lab, and the
   attacker/defender view of virtualized systems.
3. **[01-namespaces-and-cgroups.md](01-namespaces-and-cgroups.md)** - build a
   container *by hand* and see how isolation really works (and how it leaks).
4. **[02-docker-and-compose.md](02-docker-and-compose.md)** - build your own
   Docker image, then run a Minecraft server with Docker Compose.
5. **[03-container-escape-and-mitigation.md](03-container-escape-and-mitigation.md)**
   - perform a real container escape (web shell → host takeover) on your own
   disposable VM, then harden it so the escape fails.

> An alternative version of Lab 03 using the Docker socket is available in
> `03-ALT-docker-socket-escape.md` - run either one, not both.

---

## Quick start

You install only **VirtualBox** and **Vagrant** - everything else is built for
you. From the folder with the `Vagrantfile`:

```bash
vagrant up        # build + boot the VM (first run takes a while)
vagrant ssh       # log in, or use the XFCE desktop in the VirtualBox window
```

Full steps, including the common "doesn't support the provider" fix, are in
[SETUP.md](SETUP.md).

### Device requirements

Use your own laptop if it's **Windows 10/11 (64-bit)**, an **Intel Mac**, or
**Linux (64-bit)**. **Apple Silicon Macs (M1/M2/M3/M4)** and Chromebooks/tablets
can't run the x86 VM - come in person to **Lab S617** and use a workstation.
Everyone's welcome.

---

## What's in this folder

```
.
|--- SETUP.md                 # install + run the VM (start here)
|--- 00-foundations-...md      # concepts + attack/defense
|--- 01-namespaces-...md       # containers by hand
|--- 02-docker-and-compose.md  # Docker + Compose (build a web app, run Minecraft)
|--- 03-container-escape-and-mitigation.md   # perform + fix a container escape
|--- Vagrantfile               # defines the workshop VM
|--- bootstrap.sh              # provisions it (Docker, LXC, XFCE desktop)
\--- docker-demo/
    |--- webapp/               # Lab 02 Part 2-3: build your own image
    |   |--- Dockerfile
    |   |--- entrypoint.sh
    |   \--- index.html
    |--- minecraft/            # Lab 02 Part 4-5: run a server with Compose
    |   \--- docker-compose.yml
    \--- escape/               # Lab 03: vulnerable + hardened stacks
        |--- site/index.php    #   the deliberately vulnerable app (lab only)
        |--- docker-compose.yml           # misconfigured (vulnerable)
        \--- docker-compose.hardened.yml  # the fix
```

---

## What you'll walk away with

- A reproducible virtual lab you can rebuild anytime with one command.
- Real **Docker, Docker Compose, and Linux** skills for your resume.
- Hands-on experience **performing and remediating a container escape** - a
  standout most junior candidates have never done.
- Understanding of container internals, escape techniques, and how to defend
  against them.
- A documented project committed to this repo - proof of skill you can show an
  employer. (Each lab ends with a "Show it off" / portfolio section.)

Submit your work under `submissions/<your-username>/` via a pull request.

---

*Hosted by the HCCC Cybersecurity Program . github.com/CyberLab-S617/s617*
