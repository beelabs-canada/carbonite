package Carbonite::Command::user;

use Mojo::Base 'Mojo::Console';
use Mojo::Util qw/dumper getopt hmac_sha1_sum/;


# Short description
has description => 'manage users for the admin portal';

# Usage message from SYNOPSIS
has usage => sub { $_[0]->extract_usage };

sub run  {
  my ($self, @args) = @_;

  die $self->usage unless getopt \@args, 'v|verbose' => \my $_verbose, 'e|email=s' => \my $_email;

  my ( $secret, $dbh, $name ) = ( 
    $self->app->config->{secrets}[0],
    $self->app->{dbh},
    $self->ask('What is the users full name?')
  );
  
  my $email = $self->unique('email', 'What is the users email address?' );

  # set username and password
  my $username = $self->unique('username','What is the username for the user?');
  my $password = hmac_sha1_sum $secret, $self->ask('what is the password for the user?');

  # add to DB;
  $self->app->{dbh}->query('INSERT into users VALUES (:id, :name,:email,:username,:password)',{
    id => $self->last_id('users') + 1,
    name => $name,
    email => $email,
    username => $username,
    password => $password
  });

  
}

sub unique {
  my ($self, $col, $question, $_tries ) = @_;
  my $tries = ($_tries) ? $_tries : 1;
  my $value = $self->ask( $question );
  if ( $self->app->{dbh}->select_one('SELECT id from users WHERE '.$col.'=?', [$value])  )
  {
    if ( $tries > 2 )
    {
      $self->error("  [user.add] error the $col provided already exists, aborting since you have expended the number of tries (Try: $tries/3)." );
    }
    $self->warn("  [user.add] $col already existins in the database please try again (Try: $tries/3)\n" );
    return $self->unique( $col, $question, ++$tries );
  }
  return $value;
}

sub last_id
{
  my ($self, $table ) = @_;
  return $self->app->{dbh}->select_one('SELECT id FROM '.$table.' ORDER BY ID DESC LIMIT 1');
}


=head1 SYNOPSIS

  Usage: carbonite user [OPTIONS]

  Options:
    -a, --add   add user to the admin portal
    -d, --delete remove user from the admin portal
    -u, --update update user from the admin portal
    -r, --reset reset password for a user from the admin portal (sends email)

=cut
1;