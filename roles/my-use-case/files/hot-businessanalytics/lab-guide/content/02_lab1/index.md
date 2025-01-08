## Lab 1: Creating Business Rules 

This lab will show you how to *create* and *validate* **business rules**. 

### Theory of the Configuration 

* **Triggers**: *Define* conditions to trigger **business events** from incoming **web requests**. **Triggers** are connected by **AND** logic per capture rule. If you set multiple *trigger rules*, **all** of them *need* to be fulfilled to *capture* a **business event**. (Mandatory) 

* **Event Metadata**: 
    * **Provider**: a server, a software tool, a third-party integration (Mandatory) 
    * **Type**: purchase, login, etc. (Mandatory) 
    * **Category**: reference from ITIL (Optional) 

* **Event Data**: extract data from the transaction 

#### Example Result 

![picture 0](../../assets/images/3632bdeeb43381886d46cd991af0c46ef79837f3ab4b794773d40f3b5488003f.png)  


### 1.1 OneAgent rule Configuration
##### Configure
1.	*Open* "**Settings**"
2.	*Open* "**Business Analytics**" menu group
3.	*Click* on "**OneAgent**"
4.	*Click* on "**Add new capture rule**"
5.	For field "**Rule name**", *copy* and *paste*:

```
Asset purchase
```

##### Configure Trigger
1.	*Click* on "**Add trigger**"
2.	For "**Data source**", *select* "**Request - Path**"
3.	For "**Operator**", *select* "**equals**"
4.	For "**Value**", *copy* and *paste*:

```
/broker-service/v1/trade/long/buy
```

##### Configure metadata (provider)
1.	For "**Event provider data source**", *select* "**Fixed value**"
2.	For "**Event provider fixed value**", *copy* and *paste*:

```
online-website
```

##### Configure metadata (type)
1.	For "**Event type data source**", *select* "**Fixed value**"
2.	For "**Event type fixed value**", *copy* and *paste*:

```
asset-purchase
```

##### Configure additional data (price)
1.	*Click* on "**Add data field**"
2.	For "**Data source**", make sure that "**Request - Body**" is *selected*
3.	For "**Field name**" and "**Path**", *copy* and *paste*:

```
price
```

#### Configure additional data (amount) 

1. *Click* on "**Add data field**" 
2. For "**Data source**", make sure that "**Request - Body**" is *selected* 
3. For "**Field name**" and "**Path**", *copy* and *paste*: 
   
```
amount 
```

**At the bottom of the screen, click "Save changes"**

### 1.2 Notebook
1.	*Open* "**Notebooks**"
2.	*Create* a **new notebook**
3.	*Click* on the "**+**" to add a **new section**
4.	*Click* on "**Query Grail**"
5.	Copy and *paste* the *query*:

``` 
fetch bizevents 
| filter event.type=="asset-purchase"
```

### 1.3 Processing Rule Configuration
1.	*Open* "**Settings**"
2.	*Click* on "**Business Analytics**" menu group
3.	*Click* on “**Processing**”
4.	*Click* on "**Add rule**"
5.	For "**Rule name**", *copy* and *paste*:

```
Calculate revenue
```

6.	For "**Matcher (DQL)**", *copy* and *paste*:

```
event.type=="asset-purchase"
```

##### Fields 1.1
1.	Under "**Transformation fields**", *click* on "**Add item**"
2.	For "**Type**", *select* "**double**"
3.	For "**Name**", *copy* and *paste*:

```
price
```

##### Fields 1.2
1.	Under "**Transformation fields**", *click* on "**Add item**"
2.	For "**Type**", *select* "**double**"
3.	For "**Name**", *copy* and *paste*:

```
amount
```

##### **Processor definition**
1.	For "**Processor definition**", *copy* and *paste*:

```
FIELDS_ADD(trading_volume:price*amount)
```

**At the bottom of the screen, *click* "Save changes"**

### 1.4 Bucket Assignment Rule Configuration
1.	*Open* "**Settings**"
2.	*Click* on "**Business Analytics**" menu group
3.	*Click* on "**Bucket assignment**"
4.	*Click* on "**Add rule**"
5.	For "**Rule name**", *copy* and *paste*:

```
Asset Purchase
```

6.	For "**Bucket**", *select* "**Business events (35 days) (default_bizevents)**"
7.	For "**Matcher (DQL)**", *copy* and *paste*:

```
event.type=="asset-purchase"
```

**At the bottom of the screen, *click* "Save changes"**

### 1.5 Metric Extraction Rule Configuration
1.	Open "**Settings**"
2.	*Click* on "**Business Analytics**" menu group
3.	*Click* on "**Metric extraction**"
4.	*Click* on "**Add business event metric**"
5.	For "**Key**", *copy* and *paste*:

```
bizevents.easytrade.trading_volume
```

6.	For "**Matcher (DQL)**", *copy* and *paste*:

```
event.type=="asset-purchase"
```

7.	For "**Measure**", *select* "**Attribute value**"
8.	For "**Attribute**", *copy* and *paste*:

```
trading_volume
```

**At the bottom of the screen, *click* "Save changes"**

### 1.6 Queries
##### Validate new attribute
1.	From the menu, *open* "**Notebooks**"
2.	*Click* on the "**+**" to add a new section
3.	*Click* on "**Query Grail**"
4.	*Copy* and *paste* the **query**:

```
fetch bizevents 
| filter event.type == "asset-purchase"
| fields price, amount, trading_volume
```

##### Validate metric
1.	*Click* on the "**+**" to add a new section
2.	*Click* on "**Query Grail**"
3.	*Copy* and *paste* the **query**:

```
timeseries avg(bizevents.easytrade.trading_volume)
```

4.	*Click* on "**Run query**"
5.	*Wait* for the **first data points** to appear
