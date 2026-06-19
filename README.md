# OTOBO modul: CustomerCompanyCreate
by Brontosaurus Services GmbH

This [OTOBO](https://otobo.io/en/) event module automatically creates a TimeAccounting project whenever a new Customer Company is created. The generated project uses the Customer Company's name and is created in the [TimeAccounting](https://otobo-docs.softoft.de/de/administration/plugins/time-accounting/) plugin.

## Requirements
- OTOBO
- TimeAccounting plugin

## Build .opm package
1. Clone the repo into the OTOBO docker container:<br>
`docker exec -it otobo-web-1 git clone <path to repo>`
2. Give otobo user read permission:<br>
`docker exec -it --user root otobo-web-1 chown -R otobo:otobo /opt/otobo/<module_repo>/`
3. Build package:<br>
`docker exec -it --user otobo otobo-web-1 /opt/otobo/bin/otobo.Console.pl Dev::Package::Build <path>/TimeAccountingProjectCreate.sopm <target path>`


## Installation
Installation of the package is possible via CLI or GUI.

### CLI
1. Copy .opm file to target container:
2. Install package:<br>`docker exec -it --user otobo otobo_web_1 bin/Console.otobo.pl Admin::Package::Install /opt/otobo/TimeAccountingProjectCreate-1.0.0.opm`

### GUI
1. Log into OTOBO instance as an Administrator.
2. Go to Admin → Package Manager.
3. In the "Actions" sidebar on the left, click Choose File under "Add Package".
4. Select the YourModule-1.0.0.opm file from your local computer and click Install Package.

## Testing
This modul was manually tested on a test server (clone of production server).