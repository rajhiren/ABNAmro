#!/usr/bin/env perl
#------------------------------------------------------------------------
# Copyright (c) 2018-2019 Hiren Raj
# Author  : Hiren Raj
#------------------------------------------------------------------------
package ABNAmro::FileProcessing;

use utf8;
use Modern::Perl '2013';
use Carp;
use Data::Dumper;
use Text::CSV;
use ABNAmro::Logger;

#----------------------------------------------------------------
# Syntax  : my $file_processing = ABNAmro::FileProcessing->new();
#----------------------------------------------------------------
sub new {
  my ($class) = @_;
  my $self = {
    logger => ABNAmro::Logger->new(),
  };
  return bless $self, $class;
}

#----------------------------------------------------------------
# Syntax  : my $is_file_valid = $file_processing->validate_file($file);
#----------------------------------------------------------------
sub validate_file {
  my ($self, $file) = @_;

  croak "Must provide file name as param!" unless defined $file;

  #-- get extention of file with . to check weather it is .txt file or not
  my ($ext) = $file =~ /(\.[^.]+)$/;

  my $is_file_valid =  ($ext eq ".txt") ? return 1 : return 0;

  if ($is_file_valid) {
    $self->{logger}->set_logs("info","Filname : $file");
    return 1;
  } else {
    $self->{logger}->set_logs("error","There is wront type of file : $file");
    return 0;
  }
}

#----------------------------------------------------------------
# Syntax  : my @daily_summary = $file_processing->process_file($file);
#----------------------------------------------------------------
sub process_file {
  my ($self, $file) = @_;

  croak "Must provide file as param!" unless defined $file;

  $self->{logger}->set_logs("info","Initializing reading of file now");

  my @daily_summary;
  my $line = 0;
  #-- open file and read it
  open (my $data, '<', $file) or  die "could not open $file \n";

  $self->{logger}->set_logs("info","lets start processing of file now");

  while ( my $string = <$data>) {

    $line++;

    if ( length $string < 178 ) {
      $self->{logger}->set_logs("error","Minimum length row violation on line $line : $string");
      die colored("There is something wrong with this row $line : $string \n\n","red");

      #-- enable this line if you still want to generate record excluding currpted row
      # next;
    }

    #-- clean up string
    chomp $string;

    #-- we could have assign this to just an array called @test however I decided to assign them to variable for my better understanding
    my ($recode_code,$client_type,$client_number,$account_number,$subaccount_number,$opposite_party_code,$product_group_code,$exchange_code,$symbol,$expiration_date,$currency_code,$movement_code,$buy_sell_code,$quantity_long_sign,$quantity_long,$quantity_short_sign,$quantity_short) = unpack ("A3 A4 A4 A4 A4 A6 A2 A4 A6 A8 A3 A2 A1 A1 A10 A1 A10", $string);
    my $client_information = $client_type.$client_number.$account_number.$subaccount_number;
    my $product_information = $exchange_code.$product_group_code.$symbol.$expiration_date;
    my $total_tx_amount = ( $quantity_long - $quantity_short );

    #-- push necessary information to an array
    push ( @daily_summary,   [$client_information,$product_information,$total_tx_amount]  );
  }

  if (scalar @daily_summary > 0) {
    $self->{logger}->set_logs("info","processing finished and data is stored in array");
    return @daily_summary;
  } else {
    return undef;
  }

}

#----------------------------------------------------------------
# Syntax  : my $is_report_generated = $file_processing->generate_daily_report_csv(@daily_summary);
#----------------------------------------------------------------
sub generate_daily_report_csv {
  my ($self, @daily_summary) = @_;

  croak "Must supply daily summary array as param!" unless @daily_summary;

  if (scalar @daily_summary > 0) {
    $self->{logger}->set_logs("info","atleast there is one row to create output file");
  } else {
    $self->{logger}->set_logs("warn","Empty array hence nothing to process");
  }

  my $output_file = "Output.csv";

  my $csv = Text::CSV->new ({
              binary    => 1,   # Allow special character. Always set this
              auto_diag => 1,   # Report irregularities immediately
              sep_char => ',',  # Separator
              eol => $/ ,
            });

  #-- configure headings for output.csv file
  my (@heading) =  ["Client_Information","Product_Information","Total_Transaction_Amount"];

  #-- open file to append data
  open (my $fh,  ">:encoding(utf8)", $output_file) or die " $output_file : $!";

  #-- add heading to csv
  $csv->print($fh, @heading);

  #-- add each row from array to csv
  $csv->print ($fh, $_) for @daily_summary;
  close $fh or die "$output_file: $!";

  if(-e -f -r $output_file){
    print "File $output_file exists and readable\n";
    print "Output FileName : \t" .$output_file . "\n\n";
    return 1;
  } else {
    return 0;
  }
}


1;
