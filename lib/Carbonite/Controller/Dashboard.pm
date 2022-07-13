package Carbonite::Controller::Dashboard;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub home {
  
  my ($self) = @_;
  # Render template "dashbaord/home.html.ep" with message
  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
}

sub test {
  
  my ($self) = @_;
  # Render template "example/welcome.html.ep" with message
  $self->render(text => 'this is a test');
}

1;
