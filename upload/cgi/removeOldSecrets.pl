#!/usr/bin/perl -w

# Description: One Time Secret Scytl's Software
# Author: mario.vazquez[at]scytl.com
# Date: 10/12/2014

use strict;
use warnings;
use DBI;
use POSIX qw(strftime);

## GLOBAL VARS ##
my $dbServer = "127.0.0.1";
my $dbUser = "root";
my $dbPassword = "oziB8hxLxYJajAoqXKFJ";
my $dbName = "onetimesecret";
my $executionTimeStamp = strftime "%Y-%m-%d %H:%M:%S", localtime;

## FUNCTIONS ##

sub dbConnect()
{
    my $connector = "dbi:mysql:$dbName";
    my $dbLink = DBI->connect($connector,$dbUser,$dbPassword) or die "Connection error: $DBI::errstr\n";
    return $dbLink;
}

sub getAllSecrets()
{
    my $dbLink = &dbConnect();
    my $query = "SELECT token,creationtime,timetolive FROM data";
    my $statement = $dbLink->prepare($query);
    $statement->execute or die "SQL ERROR: $DBI::errstr\n";
    my @rows;
    my $secretLine;
    while (my @row = $statement->fetchrow_array) 
    {
        $secretLine = $row[0].";".$row[1].";".$row[2];
        push (@rows, $secretLine);
    }
    return @rows;
}

# returns 0 if date1 and date2 equals, 1 if date1 is higher than date 2, -1 if date1 is lower than date2
sub dateDiff()
{
    my($calcDate1,$calcDate2) = @_;
    my ($year1,$year2,$month1,$month2,$day1,$day2,$hour1,$hour2,$min1,$min2,$sec1,$sec2,$date1,$date2,$time1,$time2); 
    ($date1,$time1) = split(" ",$calcDate1);
    ($date2,$time2) = split(" ",$calcDate2);
    ($year1,$month1,$day1) = split("-",$date1);
    ($hour1,$min1,$sec1) = split(":",$time1);
    ($year2,$month2,$day2) = split("-",$date2);
    ($hour2,$min2,$sec2) = split(":",$time2);
    $date1 = $year1.$month1.$day1;
    $date2 = $year2.$month2.$day2;
    $time1 = $hour1.$min1.$sec1;
    $time2 = $hour2.$min2.$sec2;
    my $dateDiff = $date1-$date2;
    my $timeDiff = $time1-$time2;
    my $returnValue;
    if ($dateDiff < 0 )
    {
        $returnValue = -1;
    }
    elsif ($dateDiff == 0)
    {
        if ($timeDiff < 0 )
        {
            $returnValue = -1;
        }
        elsif ($timeDiff == 0)
        {
            $returnValue = 0;
        }
        else
        {
            $returnValue = 1;
        }
    }
    else
    { 
        $returnValue = 1;
    }
    return $returnValue;
}

sub getSecretsToDrop()
{
    my @secrets = @_;
    my ($token,$creationTime,$timeToLive);
    my @tokensToDrop;
    foreach my $secret (@secrets)
    {
        ($token,$creationTime,$timeToLive) = split(";",$secret);
        if (((&dateDiff($executionTimeStamp,$timeToLive) eq 1)) || ((&dateDiff($executionTimeStamp,$timeToLive) eq 0)))
        {
            push(@tokensToDrop,$token); 
        }
    }
    return @tokensToDrop;
}

sub dropTokens()
{
    my @tokensToDrop = @_;
    my $dbLink = &dbConnect();
    my ($query1,$query2,$query3,$statement1,$statement2,$statement3);
    if (scalar(@tokensToDrop)>0)
    {
        foreach my $token (@tokensToDrop)
        {
            $query1 = "UPDATE data SET status = '1' WHERE token = '$token'";
            $query2 = "DELETE FROM data WHERE token = '$token'";
            $query3 = "DELETE FROM tokens WHERE token = '$token'";
            $statement1 = $dbLink->prepare($query1);
            $statement2 = $dbLink->prepare($query2);
            $statement3 = $dbLink->prepare($query3);
            $statement1->execute or die "SQL ERROR: $DBI::errstr\n";
            $statement2->execute or die "SQL ERROR: $DBI::errstr\n";
            $statement3->execute or die "SQL ERROR: $DBI::errstr\n";
        }
    }
}


## MAIN ##
&dropTokens(&getSecretsToDrop(&getAllSecrets));
