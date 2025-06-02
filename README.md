# pty-mcp-server

----
## ⚠️ Caution

**Do not grant unrestricted control to AI.**  
Unsupervised use or misuse may lead to unintended consequences.  
All AI systems must remain strictly under human oversight and control.  
Use responsibly, with full awareness and at your own risk.  

----

`pty-mcp-server` is a Haskell implementation of the MCP (Model Context Protocol),
designed to enable AI agents to acquire and control PTY (pseudo-terminal) connections dynamically.

Through MCP, AI can interact with external CLI-based tools in a structured, automated, and scriptable way,  
leveraging PTY interfaces to execute tasks in real environments.

As an MCP server, `pty-mcp-server` operates strictly in **stdio** mode, communicating with MCP clients exclusively via standard input and output (stdio).

---

## User Guide (Usage and Setup)

### Features

`pty-mcp-server` provides the following built-in tools for powerful and flexible automation:

#### Available Tools
- **`pty-connect`**  
  Launches any command through a PTY interface with optional arguments.  
  Great for general-purpose terminal automation.

- **`pty-bash`**  
  Starts an interactive Bash shell (`/bin/bash -i -l`) in a pseudo-terminal.  
  Empowers AI to execute shell commands like a real user.

- **`pty-ssh`**  
  Opens a remote SSH session via PTY, enabling access to remote systems.  
  Accepts user/host and SSH flags as arguments.

- **`pty-cabal`**  
  Launches a cabal repl session within a specified project directory, loading a target Haskell file.  
  Supports argument passing and live code interaction.

- **`pty-stack`**  
  Launches a stack repl session within a specified project directory, loading a target Haskell file.  
  Supports argument passing and live code interaction.

- **`pty-ghci`**  
  Launches a GHCi session within a specified project directory, loading a target Haskell file.  
  Supports argument passing and live code interaction.

- **`pty-message`**  
  Sends input to an existing PTY session (e.g., `df -k`) without needing full context of the current terminal state.  
  Abstracts interaction in a programmable way.

- **`Scriptable CLI Integration`**  
  The `pty-mcp-server` supports execution of shell scripts associated with registered tools defined in `tools-list.json`. Each tool must be registered by name, and a corresponding shell script (`.sh`) should exist in the configured `scripts/` directory.

  This design supports AI-driven workflows by exposing tool interfaces through a predictable scripting mechanism. The AI can issue tool invocations by name, and the server transparently manages execution and interaction.  
  To add a new tool:
    1. Create a shell script named `your-tool.sh` in the `scripts/` directory.
    2. Add an entry in `tools-list.json` with the name `"your-tool"` and appropriate metadata.
    3. No need to recompile or modify the server — tools are dynamically resolved by name.

  This separation of tool definitions (`tools-list.json`) and implementation (`scripts/your-tool.sh`) ensures clean decoupling and simplifies extensibility.


### Example Use Cases

- Performing interactive REPL operations (e.g., using GHCi or other CLI-based REPLs)
- Interactive debugging of Haskell applications
- System diagnostics through bash scripting
- Remote server management via SSH
- Dynamic execution of CLI tools in PTY environments

### Requirements

- GHC >= 9.12
- Linux environment (PTY support required)
- On Windows, use within a WSL (Windows Subsystem for Linux) environment

### Dependencies

This package depends on the following packages:  
- [`pms-ui-request`](https://github.com/phoityne/pms-ui-request)
- [`pms-ui-response`](https://github.com/phoityne/pms-ui-response)
- [`pms-infrastructure`](https://github.com/phoityne/pms-infrastructure)
- [`pms-application-service`](https://github.com/phoityne/pms-application-service)
- [`pms-domain-service`](https://github.com/phoityne/pms-domain-service)
- [`pms-domain-model`](https://github.com/phoityne/pms-domain-model)

### How to Run

The `pty-mcp-server` application is executed from the command line.

#### Usage

```sh
$ pty-mcp-server -y config.yaml
```
While the server can be launched directly from the command line, it is typically started and managed by development tools that integrate an MCP client—such as Visual Studio Code. These tools utilize the server to enable interactive and automated command execution via PTY sessions.

#### VSCode Integration: `.vscode/mcp.json`

To streamline development and server invocation from within Visual Studio Code, the project supports a `.vscode/mcp.json` configuration file.

This file defines how the `pty-mcp-server` should be launched in a development environment. Example configuration:

```json
{
  "servers": {
    "pty-mcp-server": {
      "type": "stdio",
      "command": "pty-mcp-server",
      "args": ["-y", "/path/to/your/config.yaml"]
    }
  }
}
```

### config.yaml Configuration ([ref](./configs/pty-mcp-server.yaml))
- `logDir`:  
  The directory path where log files will be saved. This includes standard output/error logs and logs from script executions.

- `logLevel`:  
  Sets the logging level. Examples include `"Debug"`, `"Info"`, and `"Error"`.

- `scriptsDir`:  
  Directory containing script files (shell scripts named after tool names, e.g., `ping.sh`). If a script matching the tool name exists here, it will be executed when the tool is called.  
  This directory must also contain the `tools-list.json` file, which defines the available public tools and their metadata.

- `prompts`:  
  A list of prompt strings used to detect interactive command prompts. This allows the AI to identify when a command is awaiting input. Examples include `"ghci>"`, `"]$"`, `"password:"`, etc.

### Installation

You can install `pty-mcp-server` using `cabal`:

```bash
cabal install pty-mcp-server
```
*Note: The package is currently being prepared for release on Hackage.*

---

## Architecture Guide (Software Architecture and Technical Details)

### Architectural Strategy

The architecture of the `pty-mcp-server` project is designed with medium-to-large scale systems in mind. Emphasis is placed on **modularity**, **maintainability**, and **scalability**, especially in environments involving multiple teams or organizations.

To achieve these goals, the system is structured as a collection of well-separated packages, each responsible for a specific concern or domain. This package-oriented design provides several strategic benefits.

The overall package structure adheres to the principles of **Onion Architecture**, reflecting a layered design that places the domain model at the core. Furthermore, the **internal module structure within each package** is also guided by a layered approach, maintaining clear separation between pure data definitions, domain services, and infrastructure concerns.

---

### Role of `pty-mcp-server` as a Dependency Injector

In addition to managing REPL communication, `pty-mcp-server` is **not merely an executable module**, but also acts as a **dependency injector** for the entire system.

- It is capable of **referencing all relevant PMS packages**, including those that it depends on.
- This allows it to **construct and wire together application components** across multiple packages and modules in a unified manner.
- By centralizing this dependency resolution, `pty-mcp-server` provides a single point of control over **cross-cutting dependencies**, improving visibility and control over the system architecture.

As a result, inter-package and inter-module dependencies can be **centrally coordinated and managed**, which promotes better encapsulation, reusability, and testability throughout the system.

---

### Rationale for Package Separation

- **Clear Interface Definition**  
  Each package exposes only its minimal, well-defined public API. This enforces clean module boundaries and reduces unintended dependencies between components.

- **Team and Vendor Ownership**  
  In larger projects, different teams or external vendors can own specific packages. Clear separation ensures well-defined responsibilities and supports collaborative development across organizational boundaries.

- **Repository and Release Independence**  
  Packages can be split into separate repositories and versioned independently. This allows for modular development and flexible release workflows, reducing build times and simplifying integration.

- **Improved Maintainability and Extensibility**  
  By isolating concerns, the impact of code changes is limited to relevant modules. This minimizes regressions and facilitates safe, incremental improvements over time.

---

### Intended Use Cases

- Medium-to-large scale enterprise systems involving multiple developers or teams  
- Modular systems with independent development and release cycles for components  
- Projects that require long-term maintainability, extensibility, and isolation of concerns

---

This architecture follows a layered and modular approach. Domain models, domain services, application logic, and infrastructure concerns are each encapsulated in their own package, enabling clean composition while preserving separation of responsibilities.


### Deployment Diagram
![Deployment Diagram](https://raw.githubusercontent.com/phoityne/pty-mcp-server/main/docs/01-1.png)

### Package Structure
![Package Structure](https://raw.githubusercontent.com/phoityne/pty-mcp-server/main/docs/01-2.png)

### Demo haskell cabal repl
![Package Structure](https://raw.githubusercontent.com/phoityne/pty-mcp-server/main/docs/demo_cabal.gif)
ref : [prompt](./assets/prompts/haskell-cabal-debug-prompt.md)

### Demo bash
![Package Structure](https://raw.githubusercontent.com/phoityne/pty-mcp-server/main/docs/demo_bash.gif)

### Demo shellscript
![Package Structure](https://raw.githubusercontent.com/phoityne/pty-mcp-server/main/docs/demo_script.gif)
