## Lab 2: basic configuration and exploration 

This lab will show you how to "**Process**" your data to help increase revenue and reduce risk in your business.

### 1.1 OpenPipeline Pipeline Configuration

1. *Open* "**OpenPipeline**" 
1. *Click* on "**Business events**" menu group
1. *Click* on "**Pipelines**"
1. *Create* a **new pipeline**
1. *Rename* the pipeline:

      ```
      Vegas Pipeline
      ```

### 1.2 OpenPipeline Processing Rule Configuration

1.	*Access* the "**Processing**" tab
1.	From the processor dropdown menu, *Select* "**DQL**" 
1.	*Name* the new processor, *copy* and *paste*:

      ```
      Vegas Gaming Details - rqBody
      ```

1.	For "**Matching condition**", leave set to **true**
1.	For "**DQL processor definition**", *copy* and *paste*:

      ```
      parse rqBody, "JSON:json"
      | fieldsFlatten json
      ```

1.    Add another processor
1.	From the processor dropdown menu, *Select* "**DQL**" 
1.	*Name* the new processor, *copy* and *paste*:

      ```
      Vegas Gaming Details - rsBody
      ```

1.	For "**Matching condition**", leave set to **true**
1.	For "**DQL processor definition**", *copy* and *paste*:

      ```
      parse rsBody, "JSON:json"
      | fieldsFlatten json
      ```
### 1.3 OpenPipeline Metrics Extraction

1.	*Access* the "**Metric Extraction**" tab
1.	From the processor dropdown menu, *Select* "**Value Metric**" 
1.	*Name* the new Value metric, *copy* and *paste*:

      ```
      BetAmount
      ```
1.	For "**Matching condition**", *copy* and *paste*:

      ```
      isnotnull(json.BetAmount)
      ```
1.	For "**Field Extraction**", *copy* and *paste*:

      ```
      json.BetAmount
      ```      
1.	For "**Metric key**", *copy* and *paste*:

      ```
      bizevents.vegas.betAmount
      ```      
1.    For "**Dimensions**" select **custom**, *copy* and *paste*:
1.    Field name on record:
      ```
      json.Game
      ```   
1.    Dimension name:
      ```
      Game
      ```   
1.   Click "**Add dimension**" on the right hand side.
1.   Now, do the same for these other fields:
      ```
      json.CheatType 
      ``` 
      ```
      json.CustomerName
      ``` 
      ```
      json.CheatActive
      ```
1.   Click the 3 vertical buttons on your "**BetAmount**" metric, and select "**Duplicate**"
1.   Change the "**Name**", *copy* and *paste*:
      ```
      WinAmount
      ```
1.   Change the "**Matching Condition**", *copy* and *paste*:
      ```
      isNotNull(json.WinningAmount)
      ```
1.   Change the "**Field extraction Condition**", *copy* and *paste*:
      ```
      json.WinningAmount
      ```      
1.   Change the "**Metric key**", *copy* and *paste*:
      ```
      bizevents.vegas.winAmount
      ```         
**At the top right of the screen, click "*Save*"**


### 1.4 OpenPipeline Dynamic Routing

1. *Access* the "**Dynamic routing**" tab
1. *Create* a *new Dynamic route*
1. For "**Name**", *copy* and *paste*: 

      ```
      Vegas Pipeline
      ```

1. For "**Matching condition**", *copy* and *paste*:

      ```
      matchesPhrase(event.provider, "Vegas ")
      ```

1. For "**Pipeline**", *select* "**Vegas Pipeline**"
1. *Click* "**Add**" 

**Just above the table, click "*Save*"**
**Make sure you change Status to enable the Dynamic Routing**


### *PLAY SOME OF THE VEGAS APPLICATIONS IN THE WEBSITE, ACTIVATE CHEATS FOR BIG WINS* ###
### *CAREFUL, CHEATERS NEVER PROSPER!* ###

### 1.5 Queries

##### Validate new attribute
1.	From the menu, *open* "**Notebooks**"
1.	*Click* on the "**+**" to add a new section
1.	*Click* on "**DQL**"
1.	*Copy* and *paste* the **query** - Change the **Game** to the one you are testing with surrounded by quotation marks:

      ```
      Fetch Bizevents
      | filter json.Game == "**game Name**"
      ```
