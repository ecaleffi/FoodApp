package FoodApp::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

FoodApp::Schema::Result::User

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'char'
  is_nullable: 0
  size: 32

=head2 surname

  data_type: 'char'
  is_nullable: 0
  size: 32

=head2 password

  data_type: 'char'
  is_nullable: 0
  size: 64

=head2 address

  data_type: 'char'
  is_nullable: 1
  size: 64

=head2 city

  data_type: 'char'
  is_nullable: 1
  size: 32

=head2 province_state

  data_type: 'char'
  is_nullable: 1
  size: 32

=head2 postal_code

  data_type: 'char'
  is_nullable: 1
  size: 10

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "char", is_nullable => 0, size => 32 },
  "surname",
  { data_type => "char", is_nullable => 0, size => 32 },
  "password",
  { data_type => "char", is_nullable => 0, size => 64 },
  "address",
  { data_type => "char", is_nullable => 1, size => 64 },
  "city",
  { data_type => "char", is_nullable => 1, size => 32 },
  "province_state",
  { data_type => "char", is_nullable => 1, size => 32 },
  "postal_code",
  { data_type => "char", is_nullable => 1, size => 10 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 orders

Type: has_many

Related object: L<FoodApp::Schema::Result::Order>

=cut

__PACKAGE__->has_many(
  "orders",
  "FoodApp::Schema::Result::Order",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 have_right_to

Type: has_many

Related object: L<FoodApp::Schema::Result::HaveRightTo>

=cut

__PACKAGE__->has_many(
  "have_right_to",
  "FoodApp::Schema::Result::HaveRightTo",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 handel_orders

Type: has_many

Related object: L<FoodApp::Schema::Result::HandelOrder>

=cut

__PACKAGE__->has_many(
  "handel_orders",
  "FoodApp::Schema::Result::HandelOrder",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-11-08 18:48:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jG/0swRq7TKqzA8m1kGC5w

__PACKAGE__->many_to_many(roles => 'have_right_to', 'role');

# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
