#!/usr/bin/perl

# This script checks linux md devices and whether their paths are online

my @mddev; my @mderr;
my $mddev; my $mdinf;
my $mdadm="/sbin/mdadm";
my $mderr;

# check for degraded md paths

if (-e "$mdadm" ) {
  @mddev=`ls /dev/md*`;
  foreach $mddev (@mddev) {
    chomp($mddev);
    $mdinf=`$mdadm --detail $mddev 2>&1 |grep 'State :' |awk '{print \$4}'`;
    $mdinf=~s/ //g;
    $mdinf=~s/clean,//g;
    chomp($mdinf);
    if ($mdinf!~/does not appear to be active/) {
      if ($mdinf=~/degraded/) {
        push (@mderr,"$mdinf ($mddev)");
      }
    }
  }
}

# If there are errors print them

if (@mderr=~/[0-9]|[a-z]/) {
  foreach $mderr (@mderr) {
    print "WARNING: $mderr\n";
  }
}

