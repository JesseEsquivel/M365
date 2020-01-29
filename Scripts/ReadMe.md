# M365
Office 365 U.S. Government Defense

# Various Things
A collection of scripts and items used for M365 in IL5.

# USGovDoD-O365-Endpoints
A PowerShell script that runs as a job and queries the Microsoft Office 365 URLs and IPs REST API for changes.  If changes are detected the script dumps the URLs and IPs in various formats (JSON, Text, etc.), creates a proxy autoconfiguration file (PAC), and sends mail notifcation that they have changed.  Useful for making sure organizations have awareness on the changes Microsoft makes.

# Add Trusted CAs to Tenant
A PowerShell function to add all of the DoD root and intermediate CA certificates to an Azure Active Directory tenant.  These will have to be present if using legacy certificate based authentication for exchange mail on mobile devices.
