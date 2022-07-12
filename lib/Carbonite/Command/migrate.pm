package Carbonite::Command::migrate;

use Mojo::Base 'Mojolicious::Command';
use DB::SQL::Migrations::Advanced;


# Short description
has description => 'migrate the current migration files to DB';

# Usage message from SYNOPSIS
has usage => sub { $_[0]->extract_usage };

sub run  {
  my ($self, @args) = @_;
  # lets add support for NOW function which is not currently supported by SQLlite;
  my $migrator = DB::SQL::Migrations::Advanced->new(
    dbh     => $self->app->{dbh},
    folder  => $self->app->home->child('db')->to_string
  );
  $migrator->run;
}


=head1 SYNOPSIS

  Usage: carbonite migrate [OPTIONS]

  Options:
    -f, --file   migrate specific file

=cut
1;