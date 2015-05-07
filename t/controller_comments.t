use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Blog';
use Blog::Controller::comments;

ok( request('/comments')->is_success, 'Request should succeed' );
done_testing();
