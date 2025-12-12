## Lab 3: getting value from automation

In this hands-on, we’ll be setting up this process using some existing building blocks! You will be capturing cheat logs, then using automation you will reduce the risk and increase revenue for your casino. 
### 3.1 Capturing the logs
1. Using the “**App drawer**” in the top-left of the screen (or the search) – *find* the **“Settings”** app and *open* it.
1. *Choose* “**+ Collect and Capture**” on the left panel, *choose* "**Log monitoring**" and *choose* "**Log Custom log sources**"
1. The first thing to do is *choose* **when this Workflow will run** – for the purpose of this exercise we will *choose* the “**On demand**” trigger at the bottom, so it will *only* be executed when you hit **“Run"**.
1. *Click* "**Add custom log source**"
1. In the "**Rule name**" field *copy* and *paste* the following:
```
Vegas Casino Cheat Detection
```
1. Change "**Log source type**" under "**Custom log source path**" to "**Log Path**"
1. At the bottom, *click* "**Add custom log source path**"
1. In the path field, *copy* and *paste* the following:
```
vegas-casino/vegas-cheat-logs/*.log
```
1. *Click* "**Save changes**"

### Go back to your Vegas Application, *Enable Cheats*, and play some games ###


### 3.2 Processing your logs to find the cheaters
1. *Open* "**OpenPipeline**" 
1. *Click* on "**Logs**" menu group
1. *Click* on "**Pipelines**"
1. *Create* a "**+ pipeline**"
1. *Rename* the pipeline:

      ```
      Vegas Cheat Logs to BizEvents
      ```

### 3.3 OpenPipeline Processing Rule Configuration

1.	*Access* the "**Processing**" tab
1.	From the processor dropdown menu, *Select* "**DQL**" 
1.	*Name* the new processor, *copy* and *paste*:

      ```
      JSON Log parser
      ```

1.	For "**Matching condition**", leave set to **true**
1.	For "**DQL processor definition**", *copy* and *paste*:

      ```
     parse content, "JSON:json"
     | fieldsFlatten json
      ```

### 3.4 Create a Business Event
1.	*Access* the "**Data extraction**" tab
1.	From the processor dropdown menu, *Select* "**Business event**" 
1.	*Name* the new processor, *copy* and *paste*:

      ```
      Cheating Attempt
      ```
1.	For "**Matching condition**", *copy* and *paste*:
      ```
     matchesPhrase(content, "cheat_active\":true")
      ```
1.   For the "**Event Type**" select *Static string*, then *copy* and *paste*:
     ```
     CheatFound
     ```
1.   For the "**Event provider**" select *Field Name*, then *copy* and *paste*:
     ```
     json.game
     ```
1.   For "**Field extraction**" leave as *Extrace all fields*.
1.   *Click* "**Save**" so you don't lose this config

### 3.5 Adding a Metric Extraction
1.   Go back into your "**Vegas Cheat Logs to BizEvents**"
1.   *Access* the "**Metric extraction**" tab
1.   From the processor dropdown menu, *Select* "**Value Metric**"
1.   *Name* the new processor, *copy* and *paste*:

      ```
      Vegas Cheating - WinAmount
      ```
1.   For "**Matching condition**", leave set to **true**
1.   For the "**Field extraction**", *copy* and *paste*:
     ```
     json.winAmount
     ```
1.   For the "**Metric Key**", then *copy* and *paste*:
     ```
     log.cheat_WinAmount
     ```
1.   For the "**Dimensions**", *select* "**custom**"
1.   In the *Field name on record*,*copy* and *paste*:
     ```
     json.cheatType
     ```
1.   In the *Dimension name*, *copy* and *paste*:
     ```
     cheatType
     ``` 
1.   *Click* on "**Add Dimension**"
1.   Do the same for these other 2 dimensions:
##### Field name on record:
     ```
     json.game
     ```
##### Dimension name
     ```
     Game
     ```
     
##### *Click* on "**Add Dimension**"
##### Field name on record:
     ```
     json.CustomerName
     ```
##### Dimension name
     ```
     CustomerName
     ```
##### *Click* on "**Add Dimension**"

1.   Click the 3 vertical buttons on your "**Vegas Cheating - WinAmount**" metric, and select "**Duplicate**"
1.   Change the *Name*, *copy* and *paste*:
     ```
     Vegas Cheating - BetAmount
     ```
1.   Change the *Field Extraction*, *copy* and *paste*:
     ```
      json.BetAmount
     ```
1.   Change the *Metric key*, *copy* and *paste*:
     ```
     log.cheat_BetAmount
     ```
##### *Click* "**Save**" so you don't lose this config

### 3.6 OpenPipeline Dynamic Routing

1. *Access* the "**Dynamic routing**" tab
1. *Create* a *new Dynamic route*
1. For "**Name**", *copy* and *paste*: 

      ```
Vegas Security Logs      ```

1. For "**Matching condition**", *copy* and *paste*:

      ```
      matchesPhrase(content, "cheat_active\":true")
      ```

1.  For "**Pipeline**", *select* "**Vegas Cheat Logs to BizEvents**"
 1. *Click* "**Add**" 

### Go back to your Vegas Application, *Enable Cheats*, and play some games ###

1.  Navigate to your Dynatrace Notebook, add a new DQL widget, *copy*, *paste* and *run* the following:
    ```
    timeseries { sum(log.cheat_winAmount), value.A = sum(log.cheat_winAmount, scalar: true), sum(log.cheat_BetAmount), value.B = sum(log.cheat_BetAmount, scalar: true) }, union: TRUE
    ```
1. Change *Visualization Type* to a "**Bar**"
