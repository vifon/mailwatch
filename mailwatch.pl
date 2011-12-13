#!/usr/bin/env perl

use warnings;
use strict;
use 5.010;

use Linux::Inotify2;

sub cleanup {
    unlink "/var/lock/mailwatch-$ENV{USER}.lock" or die "unable to remove the lock file\n";
    exit(0);
}

$SIG{INT}  = \&cleanup;
$SIG{TERM} = \&cleanup;
$SIG{HUP}  = \&cleanup;
$SIG{ABRT} = \&cleanup;

if (-e "/var/lock/mailwatch-$ENV{USER}.lock") {
    die "An another instance is running\n";
} else {
    open(my $lock, '>', "/var/lock/mailwatch-$ENV{USER}.lock") or die "unable to create the lock file\n";
    close $lock;
}

my $inotify = new Linux::Inotify2;
$inotify->watch($_, IN_MOVED_TO | IN_CREATE) while <$ENV{HOME}/mail/*/new>;


while (my @events = $inotify->read) {
    for my $event (@events) {
        open(my $wmii, '|-', "wmiir create /rbar/1mail");
        print $wmii "colors #000000 #68ff05 #333333\nlabel MAIL\n";
        close $wmii;
    }
}
cleanup;
