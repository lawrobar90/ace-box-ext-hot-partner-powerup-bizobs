## Lab 3: getting value from automation

In this hands-on, we’ll be setting up this process using some existing building blocks! You will be capturing cheat logs, then using automation you will reduce the risk and increase revenue for your casino. 
### 3.1 Capturing th logs
1. Using the “**App drawer**” in the top-left of the screen (or the search) – *find* the **“Settings”** app and *open* it.
1. *Choose* “**+ Collect and Capture**” on the left panel, *choose* "**Log monitoring**" and *choose* "**Log Custom log sources**"
1. The first thing to do is *choose* **when this Workflow will run** – for the purpose of this exercise we will *choose* the “**On demand**” trigger at the bottom, so it will *only* be executed when you hit **“Run"**.
1. *Click* "**Add custom log source**"
1. In the "**Rule name**" field *copy* and *paste* the following:
```
Vegas Casino Cheat Detection
```
1. Change "**Log source type**" under "**Custom log source pathe**" to "**Log Path**"
1. At the bottom, *click* "**Add custom log source path**"
1. In the path field, *copy* and *paste* the following:
```
vegas-casino/vegas-cheat-logs/*.log
```

