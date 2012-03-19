#!/usr/bin/env perl

use warnings;
use strict;
use 5.010;

use Linux::Inotify2;
use POSIX qw(mkfifo);
use Getopt::Long;
Getopt::Long::Configure(qw(
                              bundling
                              no_ignore_case
                              no_auto_abbrev
                              auto_version
                              pass_through
                         ));

umask 0177;

my $pipePath = "/tmp/mailwatch";
my $maildir  = "$ENV{HOME}/mail";
my $clean    = 0;
my $umask    = 0177;

GetOptions(
           'dir|d|mail|m=s' => \$maildir,
           'pipe|p=s'       => \$pipePath,
           'umask=s'        => sub { umask $_[1]; $umask = $_[1] },
           'clean|c'        => \$clean,
          );

{
    local $/ = "/";
    chomp $maildir;
}

sub cleanup {
    unlink "/var/lock/mailwatch-$ENV{USER}.lock" or die "unable to remove the lock file\n";
    unlink $pipePath if $clean;
    exit(0);
}

$SIG{INT}  = \&cleanup;
$SIG{TERM} = \&cleanup;
$SIG{HUP}  = \&cleanup;
$SIG{ABRT} = \&cleanup;

if (-e "/var/lock/mailwatch-$ENV{USER}.lock") {
    die "an another instance is running\n";
} else {
    open(my $lock, '>', "/var/lock/mailwatch-$ENV{USER}.lock") or die "unable to create the lock file\n";
    close $lock;
}

my $inotify = new Linux::Inotify2;
$inotify->watch($_, IN_MOVED_TO | IN_CREATE, \&notify) while <$maildir/*/new>;


$inotify->poll while 1;
cleanup;

sub notify {
    unless (-p $pipePath) {
        unlink $pipePath if -e $pipePath;
        mkfifo $pipePath, 0777 ^ $umask;
    }
    open(my $pipe, '>', $pipePath);
    say $pipe "MAIL";
    close $pipe;
}
