#!/usr/bin/env perl -w

use strict;
#use Getopt::Long;
#use Pod::Usage;
#use Time::localtime;
use FileHandle;
use File::Basename;
#use File::Find;

our %global_config;
require "config.pl" || die("Cannot find config file!");

&create_flist($ENV{PRJ_ROOT});


#####################################################################################
#  Subroutine: BEGIN & END
#     + Built-in function
#     + Automatically invoke at begin and end of program
#####################################################################################
BEGIN {
   print("Starting the PERL program $0\n");
   print("-------------------------------------------------------\n");
}

END {
   print("\n-------------------------------------------------------\n");
   print("Ending the PERL program $0\n");
}


#####################################################################################
#  Subroutine: create_flist
#     + Create file lists to compile
#     + Specify the file extension in file config.pm
#     + Note: you need pass absolute path to this subroutine
#####################################################################################
sub create_flist {
   #----------------------------
   my ($path) = @_;
   my $dir = basename($path);
   my $dh = FileHandle->new();
   my $fh = FileHandle->new();
   my $file;
   my $ext_ptr = $global_config{EXTENSIONS};
   my @ext_lst = @$ext_ptr;
   my $ext = join('|', @ext_lst);
   #----------------------------
   opendir($dh, "$path") || die("Cannot open directory $path!\n");
   open($fh, ">$path/$dir.flist") || die("Cannot create file $dir.flist! in path $path\n");
   #----------------------------
   print("Creating file list $dir.flist ...\n");
   while($file = readdir($dh)) {
      if(-d $path.'/'.$file) {
         if(($file ne '.') && ($file ne '..')) {
            print $fh ("-f $path/$file.flist\n");
            &create_flist($path.'/'.$file);
         }
      } else {
         if($file =~ /.($ext)$/i) {
            print $fh ("-f $path/$file\n");
            #&replace_tab("$path/$file", $global_config{TAB});
         }
      }
   }
   #----------------------------
   close($fh);
   closedir($dh);
}


#####################################################################################
#  Subroutine: replace_tab
#     + Replace tab(\t) by a number of space in source file
#     + Need to run if your source code have tab
#     + Specify the number of space to repace in file config.pm
#####################################################################################
sub replace_tab {
   #----------------------------
   my ($file, $num) = @_;
   my $fh = FileHandle->new();
   my $line;
   my @line;
   my $pattern = " " x $num;
   #----------------------------
   open($fh, $file) || die("Cannot open file $file\n");
   #----------------------------
   @line = <$fh>;
   close($fh);
   for $line (@line) {
      $line =~ s/\t/$pattern/g;
   }
   open($fh, ">$file") || die("Cannot open file $file\n");
   print $fh (@line);
   close($fh);
}





 
