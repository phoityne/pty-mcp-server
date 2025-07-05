You will use the following MCP tools to perform a Telnet login sequence:

- `socket-open`
- `socket-read`
- `socket-write`
- `socket-message`
- `socket-close`

Begin by initiating the process to connect to a Telnet server.

At each step, **if any required information is missing (such as hostname, port, username, or password), prompt the user for it at that moment.**

### Step-by-step:

1. When ready to connect, use `socket-open`.  
   - If the host or port is not yet known, ask the user.

2. Use `socket-read` to receive Telnet negotiation bytes.  
   - Identify and parse `IAC DO` sequences.  
   - If the received data is in binary form, convert it to a human-readable format (e.g., hex dump or interpreted Telnet commands) and display it for clarity.

3. Respond to each `IAC DO` with `IAC WONT` using `socket-write`.  
   - Repeat steps 2 and 3 until negotiation is complete.

4. When the server prompts for a login name, send the username using `socket-message`.  
   - Ask the user for their username if not already provided.  
   - **Note:** When using `socket-message`, it automatically waits for the prompt and returns the response.  
     **You do not need to call `socket-read` separately.**

5. When the server prompts for a password, send it using `socket-message`.  
   - Prompt the user for their password only at that time.  
   - Again, no need for `socket-read` before or after.

6. After login, `socket-message` will return the post-login shell prompt or confirmation.  
   - You can stop here or proceed as needed.

7. Use `socket-close` if the user indicates the session should be terminated.

---

### Logging and Presentation Guidelines

- Always log raw socket data in binary form for debugging purposes.
- When binary data is received (e.g., Telnet negotiation sequences), **convert it to a human-readable form** (e.g., interpreted Telnet control codes or printable text) and show it alongside the raw data.
- Clearly annotate which MCP tool produced or consumed the data in each step.

