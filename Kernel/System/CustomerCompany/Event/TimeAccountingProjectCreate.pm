# --
# OTOBO is a web-based ticketing system for service organisations.
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# Copyright (C) 2019-2026 Rother OSS GmbH, https://otobo.io/
# --
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# --

package Kernel::System::CustomerCompany::Event::TimeAccountingProjectCreate; 

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::CustomerCompany',
    'Kernel::System::TimeAccounting',
);

# Construction of module object
sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    # Pass object and parameters to method.
    my ( $Self, %Param ) = @_; 

    # Check if needed infos where passed.
    for (qw(Data Event Config UserID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    return 1 if $Param{Event} ne 'CustomerCompanyAdd';
    
    # Get customer company ID.
    my $CustomerCompanyID = $Param{Data}->{CustomerID};

    if ( !$CustomerCompanyID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not extract a valid CustomerCompanyID from Event Data!"
        );
        return;
    }

    # Get customer company hash (dict).
    my %Company = $Kernel::OM->Get('Kernel::System::CustomerCompany')->CustomerCompanyGet( CustomerID => $CustomerCompanyID,
    );

    # Get customer company name.
    my $CustomerCompanyName = $Company{CustomerCompanyName};

    if ( !$CustomerCompanyName ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not extract a valid company name from Data!"
        );
        return;
    }

    # Create new project with the name of customer company.
    my $TimeAccountingObject = $Kernel::OM->Get('Kernel::System::TimeAccounting');
    my $ProjectID = $TimeAccountingObject->ProjectSettingsInsert(
        Project            => $CustomerCompanyName,
        ProjectDescription => "",
        ProjectStatus      => 1,
    );

    # Check if project was created successfully.
    if (!$ProjectID) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Failed to create Time Accounting project for: $CustomerCompanyName!"
        );  
        return;
    }

        return 1;
}

1;
