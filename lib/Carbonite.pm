package Carbonite;
use Mojo::Base 'Mojolicious';
use Mojo::URL;
use DBI;



# This method will run once at server start
sub startup {

  my ($self) = @_;
  
  # Load configuration from config file
  my $config = $self->plugin('NotYAMLConfig');

  # Configure the application
  $self->secrets($config->{secrets});

  push @{$self->app->commands->namespaces}, 'Carbonite::Command';

  # Database
  $self->app->{dbh} = $self->_db( $config );

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('Example#welcome');

  $r->get('/test')->to('Example#test');

  $r->get('/dashboard')->to('Dashboard#home');

  $self->hook( before_dispatch => sub {
    my ( $self ) = @_;
    # notice: url must be fully-qualified or absolute, ending in '/' matters.
    $self->req->url->base( Mojo::URL->new( $config->{app_url} ) );
  });
}


sub _db
{
  my ( $self, $config ) = @_;

  my $path_to_dbfile = $self->app->home->rel_file( $config->{'database'}->{'path'} );

  my $dbh = DBI->connect("dbi:SQLite:uri=file:$path_to_dbfile?mode=rwc", undef, undef, {
    RootClass => 'DBIx::Sunny',
    AutoCommit => 1,
    PrintError => 0,
    RaiseError => 1,
    sqlite_see_if_its_a_number => 1,
    sqlite_defensive => 1
  });

  # additional functions
  $dbh->sqlite_create_function( 'NOW', 0, sub { return time } );

  return $dbh;

}

1;
