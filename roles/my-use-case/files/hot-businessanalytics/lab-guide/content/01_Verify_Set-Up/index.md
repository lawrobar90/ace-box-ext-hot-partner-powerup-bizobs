## Verify Setup & Quick Start Guide

Before we begin, let's verify that you can access the application and understand how to use it effectively.

### 1. **Access Dynatrace University**
- *Open* [**university.dynatrace.com**](https://university.dynatrace.com)
- *Log in* with your **account credentials**
- *Open* the **Business Analytics event** in the section **Upcoming events**

### 2. **Verify Environment**
- *Verify* **access** to your Dynatrace Environment
- *Ensure* **OneAgent** is installed and actively monitoring your environment
- *Confirm* distributed tracing is enabled for service visibility

### 3. **About the Partner PowerUp BizObs Application**

**Partner PowerUp BizObs** is a comprehensive customer journey analytics simulator that demonstrates real-world business observability across multiple industries. The application features:

#### **🎯 Core Capabilities:**
- **Multi-Industry Templates**: Retail, Banking, eCommerce, Healthcare, and more
- **Real-Time Journey Simulation**: Execute customer journeys with live metrics
- **Advanced Port Management**: Robust system preventing service conflicts ✅
- **Distributed Service Architecture**: Each journey step runs as isolated services
- **Business Event Capture**: Automatic tagging and context propagation
- **Dynamic Journey Creation**: Build custom journeys from scratch

#### **🚀 Getting Started - Step by Step:**

1. **Access the Application**
   - *Navigate* to Dashboards in your University page
   - Open the **dashboard** and find BizObs Application
   - Open the **link**
   - *Verify* the dashboard loads with service status indicators

2. **Create Your First Journey from Scratch**
   - *Click* "**Create New Journey**" or navigate to the journey builder
   - *Enter* basic journey information:
     - **Company Name**: Your test company name
     - **Domain**: Company domain (e.g., testcorp.com)
     - **Industry Type**: Select from dropdown (Retail, Banking, etc.)

3. **Build Journey Steps**
   - *Add* journey steps one by one:
     - **ProductSelection**: Customer browses and selects products
     - **CartReview**: Customer reviews items in shopping cart
     - **Payment**: Customer completes payment process
     - **Fulfillment**: Order processing and shipping
   - *Configure* each step with:
     - **Step Name**: Descriptive name for the business process
     - **Service Name**: Auto-generated or custom service identifier
     - **Description**: Business context for the step
     - **Category**: Step classification (discovery, transaction, etc.)

4. **Configure Journey Parameters**
   - **Number of Customers**: Start with 1-2 for initial testing
   - **Think Time**: Delay between steps (250ms recommended)
   - **Error Simulation**: Optional error injection for testing
   - **Additional Fields**: Custom business data
   - **Customer Profile**: Demographics and preferences
   - **Trace Metadata**: Context for distributed tracing

5. **Execute and Monitor Your Journey**
   - *Click* "**Start Journey Simulation**"
   - *Watch* the console output for:
     - Service startup messages with port allocation
     - Real-time step execution logs
     - Business event capture confirmations
   - *Monitor* the response for:
     - Success/failure rates
     - Response times per step
     - Correlation IDs for tracing

6. **View Results and Analytics**
   - *Review* the JSON response showing:
     - **Load Test Summary**: Success rates and performance metrics
     - **Sample Journey**: Detailed execution trace
     - **Correlation IDs**: For Dynatrace trace lookup
     - **Error Details**: Any issues encountered
   - *Check* Dynatrace for:
     - Service topology with your custom services
     - Distributed traces across journey steps
     - Business events and metrics

#### **🔧 API Usage for Advanced Testing:**

**Basic Journey Simulation:**
```json
POST /api/journey-simulation/simulate-journey
{
  "journeyName": "Custom Retail Journey",
  "companyName": "TestRetail",
  "numberOfCustomers": 2,
  "steps": [
    {"stepName": "ProductSelection"},
    {"stepName": "CartReview"},
    {"stepName": "Payment"}
  ]
}
