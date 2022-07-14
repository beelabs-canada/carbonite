package MyApp::Plugin::CO22Renderer;
use Mojo::Base 'Mojolicious::Plugin';

sub register  {
    my ($self, $app, $conf) = @_;
    $app->helper('my_helpers.render_with_header' => sub ($c, @args) {
    $c->res->headers->header('X-Mojo' => 'I <3 Mojolicious!');
    $c->render(@args);
  });
}

1;