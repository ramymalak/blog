package Blog::Controller::posts;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Blog::Controller::posts - Catalyst Controller

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
$c->stash(posts => [$c->model('DB::Post')->all()]);
$c->stash(template => 'posts/list.tt');
}
sub base :Chained('/') :PathPart('posts') :CaptureArgs(0){
    my ($self, $c) = @_;
    $c->stash(resultset => $c->model('DB::Post'));
    $c->log->debug('*** INSIDE BASE METHOD ***');
}
sub form_create :Chained('base') :PathPart('add') :Args(0) {
my ($self, $c) = @_;
# Set the TT template to use
$c->stash(template => 'posts/add.tt');
}
sub post_save :Chained('base') :PathPart('save_post') :Args(0) {
    my ($self, $c) = @_;
    my $title = $c->request->params->{title} || 'N/A';
    my $body = $c->request->params->{body} || 'N/A';
    # Create the user
    my $post = $c->model('DB::Post')->create({
    title => $title,
    body => $body,
    auther_id=>$c->user( )->id,
    });
    # Store new model object in stash and set template
    #$c->stash(user => $user,template => 'users/show.tt');
    #$c->response->redirect('id'.{$user.id}.'show');
#    $c->stash(user=>$user,template=>'users/show.tt');
     $c->stash(post=>$post);
    my $myid = $post->id;
    $c->response->redirect("/pid/$myid/show");
}
#
sub object :Chained('/') :PathPart('pid') :CaptureArgs(1){
    my ($self, $c, $id) = @_;
    $c->stash(rec=>$c->model('DB::Post')->find($id));

}
sub delete_post :Chained('object') :PathPart('delete') :Args(0) {
 my ($self, $c) = @_;
 $c->stash->{rec}->delete;
# c->forward('list');
$c->response->redirect($c->uri_for('list'));

}
sub show_post :Chained('object') :PathPart('show') :Args(0) {
 my ($self, $c) = @_;
 $c->stash(post => $c->stash->{rec});
 $c->stash(comments => [$c->model('DB::Comment')->all()]);
 $c->stash(template => 'posts/show.tt');

}
sub edit_post :Chained('object') :PathPart('edit_post') :Args(0) {
 my ($self, $c) = @_;
 $c->stash(template => 'posts/edit_view.tt');
}
sub do_update :Chained('object') :PathPart('edit') :Args(0) {
 my ($self, $c) = @_;
 my $title = $c->request->params->{title};
 my $body = $c->request->params->{body};

    $c->stash->{rec}->update( {title=>$title,body=>$body } );

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
