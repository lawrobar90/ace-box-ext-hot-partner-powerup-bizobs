# Partner PowerUp BizObs - ACE-Box Extension

## Description

This ACE-Box extension replaces the EasyTrade application with the **Partner PowerUp BizObs** application - a comprehensive customer journey analytics simulation tool. The application runs directly on EC2 instances without containerization, providing business analytics capabilities across multiple industries.

### Key Features
- **Customer Journey Simulation**: Multi-step journey analytics with configurable templates
- **Industry Templates**: Pre-built scenarios for retail, banking, eCommerce, and healthcare
- **Dynamic Microservices**: 6-step service architecture (Step1Service - Step6Service)  
- **Real-time Analytics**: Business metrics, KPIs, and journey completion tracking
- **Dynatrace Integration**: Custom business events and monitoring integration
- **EC2 Native Deployment**: Direct deployment with systemd services and nginx proxy

## Version and compatibility

Please add a note pointing out which versions of the external use case are compatible with the respective ACE-Box versions:

| Release | Verified against ace-box version |
| --- | --- |
| 1.0.0 | v1.15.0 |

## Extra variables

Add notes of the extra vars needed to be configured

## DTU provisioning

When an ACE-Box with external use case is provisioned by the DTU team, make sure to grant read access to the Github [ace-box-dtu](https://github.com/orgs/dynatrace-ace/teams/ace-box-dtu) team. This allows them to source the use case during their provisioning process.
