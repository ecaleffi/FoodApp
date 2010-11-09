package FoodAppDB::Schema::Result::User;

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

FoodAppDB::Schema::Result::User

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

=head2 order_number

  data_type: 'varchar'
  is_nullable: 1
  size: 36

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
  "order_number",
  { data_type => "varchar", is_nullable => 1, size => 36 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 orders

Type: has_many

Related object: L<FoodAppDB::Schema::Result::Order>

=cut

__PACKAGE__->has_many(
  "orders",
  "FoodAppDB::Schema::Result::Order",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 have_right_to

Type: has_many

Related object: L<FoodAppDB::Schema::Result::HaveRightTo>

=cut

__PACKAGE__->has_many(
  "have_right_to",
  "FoodAppDB::Schema::Result::HaveRightTo",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-11-08 17:08:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nMCX92TMcAb7s2VlFvcwag


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
