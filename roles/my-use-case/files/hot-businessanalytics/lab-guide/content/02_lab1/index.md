## Lab 1: basic configuration and exploration 

This lab will show you how to *create* and *validate* **business rules**. 

### 1.1 OneAgent rule Configuration

##### Configure
1.	*Open* "**Settings Classic**"
1.	*Open* "**Business Analytics**" menu group
1.	*Click* on "**OneAgent**"
1.	*Click* on "**Add new capture rule**" on the **incoming** tab
1.	For field "**Rule name**", *copy* and *paste*:
      ```
      Vegas Application
      ```

##### Configure Trigger

1.	*Click* on "**Add trigger**"
1.	For "**Data source**", *select* "**Response - Body**"
1.	For "**Operator**", *select* "**exists**"
1.	For "**Value**", *copy* and *paste*:
      ```
      json.Game
      ```

##### Configure metadata (Event Provider)

1.	For "**Event provider Data Source**", *click* on "**Fixed value**" and make sure that "**Response - Body**" is *selected*
1.	For "**Field name**" and "**Path**", *copy* and *paste*:
      ```
      Game
      ```

##### Configure metadata (Event Type)

1.	For "**Event type data source**", *click* on "**Fixed value**" and make sure that "**Request - Body**" is *selected*
1.	For "**Field name**" and "**Path**", *copy* and *paste*:
      ```
      Action
      ```

##### Configure additional data (JSON Payloads)

1.	*Click* on "**Add data field**"
1.	For "**Data source**", make sure that "**Request - Body**" is *selected*
1.	For "**Field name**", *copy* and *paste*:
      ```
      rqBody
      ```
1.	For "**Path**", *copy* and *paste*:
      ```
      *
      ```

1.	*Click* on "**Add data field**"
1.	For "**Data source**", make sure that "**Response - Body**" is *selected*
1.	For "**Field name**", *copy* and *paste*:
      ```
      rsBody
      ```
1.	For "**Path**", *copy* and *paste*:
      ```
      *
      ```


**At the bottom of the screen, click "Save changes"**

### 1.2 Service Naming Rules

##### Create a Service Naming Rule for the intelligent traceing to be captured
1.	*Open* "**Settings Classic**"
1.	*Open* "**Server-side Service monitoring**" menu group
1.	*Click* on "**Service naming rules**"
1.    For Rule name, *copy* and *paste*:
      ```
      Vegas Naming Rules
      ```
1.    For Service name format, *copy* and *paste*:
      ```
      {ProcessGroup:DetectedName}
      ```
1.    For Conditions name format, *select* **Detected process group name** from the dropdown
1.    Change matcher to **begins with**
1.    For "**value**", *copy* and *paste*:
      ```
      vegas
      ```
1.    Click *Preview* then **Save changes**

### 1.3 OpenPipeline Pipeline Configuration

1. *Open* "**OpenPipeline**" 
1. *Click* on "**Business events**" menu group
1. *Click* on "**Pipelines**"
1. *Create* a **new pipeline**
1. *Rename* the pipeline:

      ```
      Vegas Pipeline
      ```

### 1.4 OpenPipeline Processing Rule Configuration

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
### 1.5 OpenPipeline Processing Rule Configuration

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


### 1.6 OpenPipeline Dynamic Routing

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

### 1.7 Queries

##### Validate new attribute
1.	From the menu, *open* "**Notebooks**"
1.	*Click* on the "**+**" to add a new section
1.	*Click* on "**DQL**"
1.	*Copy* and *paste* the **query** - Change the **Game** to the one you are testing with surrounded by quotation marks:

      ```
      Fetch Bizevents
      | filter json.Game == "**game Name**"
      ```
