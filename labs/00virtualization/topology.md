# Workshop Topology

How the workshop fits together. The key idea students should take away is the
**nesting**: a VM runs inside VirtualBox on their computer, and containers run
inside that VM. **A VirtualBox window = a VM; a shell with a different prompt
inside it = a container.**

## Technical stack (what each student runs)

```mermaid
flowchart TB
    subgraph HOST["Student Computer — Windows / Intel Mac / Linux  (or a Lab S617 workstation)"]
        BROWSER["Web browser<br/>GitHub: CyberLab-S617/s617<br/>(lab instructions)"]
        subgraph VBOX["VirtualBox — Type-2 Hypervisor  (+ Vagrant)"]
            subgraph VM["VM: s617-workshop — Ubuntu 24.04 + XFCE desktop<br/>(THIS is 'a VM' = the 'host' in Lab 03)"]
                subgraph DOCKER["Docker Engine"]
                    WEB["webapp container<br/>(image you build)  :8080"]
                    subgraph COMPOSE["Docker Compose stack — private network"]
                        MC["game<br/>browser game server  :3001"]
                        TOOLS["tools<br/>(alpine)"]
                    end
                    ESCAPE["ESCAPE LAB (Lab 03)<br/>vulnerable web app  :8081<br/>runs as root + host '/' mounted"]
                end
                HOSTFS["Host filesystem<br/>the VM's own /root, /etc, ...<br/>(target of the Lab 03 escape)"]
                LXC["LXC<br/>system containers"]
                HAND["Hand-built containers (Lab 01)<br/>unshare - namespaces - cgroups - veth"]
            end
        end
    end
    BROWSER -. "copy / paste (shared clipboard)" .-> VM
    TOOLS -. "reaches by name" .-> MC
    ESCAPE == "escapes via host '/' bind-mount" ==> HOSTFS

    classDef host fill:#e8eef7,stroke:#33415c,stroke-width:1px;
    classDef vbox fill:#dde7f0,stroke:#1f6f8b,stroke-width:1px;
    classDef vm fill:#e7f0e4,stroke:#3a7d34,stroke-width:1px;
    classDef docker fill:#e3f0fb,stroke:#1f6feb,stroke-width:1px;
    classDef cont fill:#fff6e0,stroke:#b5880f,stroke-width:1px;
    classDef danger fill:#fde0e0,stroke:#d1242f,stroke-width:2px;
    class HOST host;
    class VBOX vbox;
    class VM vm;
    class DOCKER,COMPOSE docker;
    class WEB,MC,TOOLS,LXC,HAND cont;
    class ESCAPE danger;
    class HOSTFS vm;
```

**Reading it from the outside in:**

- **Student Computer** — their own laptop (Windows / Intel Mac / Linux) or a Lab
  S617 workstation. A browser shows the lab instructions from GitHub.
- **VirtualBox (+ Vagrant)** — the Type-2 hypervisor. `vagrant up` builds the VM
  from a recipe. The shared clipboard lets students paste commands from the
  GitHub page into the VM.
- **VM `s617-workshop`** — Ubuntu 24.04 with an XFCE desktop. *This* is the
  virtual machine (its own kernel, own desktop).
- **Inside the VM:**
  - **Docker Engine** runs the **webapp** container (the image students build)
    and the **Compose stack** — a browser game server plus a `tools` container
    that reaches it by name over Docker's private network.
  - **LXC** for system containers.
  - **Hand-built containers** from Lab 01 (namespaces, cgroups, veth) — the same
    isolation Docker automates, built by hand.
  - **The Escape Lab (Lab 03)** — a deliberately misconfigured container (runs as
    root, with the host `/` bind-mounted). The red arrow shows it breaking out of
    the Docker boundary to write to the **host filesystem** — a container escape,
    performed and then fixed, all inside the student's own disposable VM.

## Delivery (hybrid — Dec 2)

```mermaid
flowchart LR
    INP["In-person students<br/>Lab S617 workstations<br/>or their own laptops"] --> LAB["Workshop session<br/>Cyber Lab S617 — Dec 2"]
    REM["Remote students<br/>Webex / Zoom"] --> LAB
    UNSUP["Unsupported device?<br/>(Apple Silicon Mac, Chromebook)"] --> INP
    LAB --> REPO["GitHub: CyberLab-S617/s617<br/>instructions + portfolio submissions (PRs)"]

    classDef a fill:#e7f0e4,stroke:#3a7d34;
    classDef b fill:#e3f0fb,stroke:#1f6feb;
    classDef c fill:#fff6e0,stroke:#b5880f;
    class INP,REM a;
    class LAB b;
    class UNSUP,REPO c;
```

A rendered image of the technical stack is in **`topology.png`** (and
`topology.svg`) for use in slides or the flyer.
