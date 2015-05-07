package Blog::Controller::Users;
use Moose;
use namespace::autoclean;
use Digest::MD5 qw(md5_hex);
BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::Users - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Blog::Controller::Users in Users.');
}

sub list :Local :Args(0) {
my ($self, $c) = @_;
$c->stash(users => [$c->model('DB::User')->all()]);
$c->stash(template => 'users/list.tt');
}
#sub base :Chained('/') :PathPart('Users') :CaptureArgs(0){
#    my ($self, $c) = @_;
#    $c->stash(resultset => $c->model('DB::User'));
#}
#sub newform :Chained('base') :PathPart('new'):CaptureArgs(0){
#    my ($self, $c) = @_;
#    $c->stash(template => 'users/reg.tt');
#}
sub base :Chained('/') :PathPart('users') :CaptureArgs(0){
    my ($self, $c) = @_;
    $c->stash(resultset => $c->model('DB::User'));
    $c->log->debug('*** INSIDE BASE METHOD ***');
}
sub form_create :Chained('base') :PathPart('reg') :Args(0) {
my ($self, $c) = @_;
# Set the TT template to use
$c->stash(template => 'users/reg.tt');
}
sub form_save :Chained('base') :PathPart('save') :Args(0) {
    my ($self, $c) = @_;
    my $username = $c->request->params->{username} || 'N/A';
    my $email = $c->request->params->{email} || 'N/A';
    my $password= $c->request->params->{password} || 'N/A';
    # Create the user
    my $user = $c->model('DB::User')->create({
    username => $username,
    email => $email,
    password => md5_hex($password)
    });
    # Store new model object in stash and set template
    #$c->stash(user => $user,template => 'users/show.tt');
    #$c->response->redirect('id'.{$user.id}.'show');
#    $c->stash(user=>$user,template=>'users/show.tt');
     $c->stash(user=>$user);
    my $myid = $user->id;
    $c->response->redirect("/id/$myid/show");
}

sub object :Chained('/') :PathPart('id') :CaptureArgs(1){
    my ($self, $c, $id) = @_;
    $c->stash(rec=>$c->model('DB::User')->find($id));

}
sub delete_user :Chained('object') :PathPart('delete') :Args(0) {
 my ($self, $c) = @_;
 $c->stash->{rec}->delete;
# c->forward('list');
$c->response->redirect($c->uri_for('list'));

}
sub show_user :Chained('object') :PathPart('show') :Args(0) {
 my ($self, $c) = @_;
 $c->stash(user => $c->stash->{rec});
 $c->stash(template => 'users/show.tt');

}
sub edit_user :Chained('object') :PathPart('edit_view') :Args(0) {
 my ($self, $c) = @_;
 $c->stash(template => 'users/edit_view.tt');
}
sub do_update :Chained('object') :PathPart('edit') :Args(0) {
 my ($self, $c) = @_;
 my $username = $c->request->params->{username};
 my $email = $c->request->params->{email};
 my $password= $c->request->params->{password};
 if ($password.length==0){
    $c->stash->{rec}->update( {username=>$username,email=>$email} );
 }else{
    $password=md5_hex($password);
    $c->stash->{rec}->update( {username=>$username,email=>$email,password=>$password } );
 }
  #$c->forward('list');
  $c->response->redirect($c->uri_for('/posts/list'));


}

=encoding utf8

=head1 AUTHOR

ramy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
