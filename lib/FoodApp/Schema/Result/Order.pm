package FoodApp::Schema::Result::Order;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "EncodedColumn");

=head1 NAME

FoodApp::Schema::Result::Order

=cut

__PACKAGE__->table("orders");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 order_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 recipe_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 batch_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "order_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "recipe_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "batch_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("user_id", "order_id");
__PACKAGE__->add_unique_constraint("batch_id_unique", ["batch_id"]);

=head1 RELATIONS

=head2 batch

Type: belongs_to

Related object: L<FoodApp::Schema::Result::ProductBatch>

=cut

__PACKAGE__->belongs_to(
  "batch",
  "FoodApp::Schema::Result::ProductBatch",
  { id => "batch_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 recipe

Type: belongs_to

Related object: L<FoodApp::Schema::Result::Recipe>

=cut

__PACKAGE__->belongs_to(
  "recipe",
  "FoodApp::Schema::Result::Recipe",
  { id => "recipe_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 order

Type: belongs_to

Related object: L<FoodApp::Schema::Result::TableOrder>

=cut

__PACKAGE__->belongs_to(
  "order",
  "FoodApp::Schema::Result::TableOrder",
  { id => "order_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 user

Type: belongs_to

Related object: L<FoodApp::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "FoodApp::Schema::Result::User",
  { id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-11-19 10:43:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SQFsIeM16tdcxCyzvh0vOw


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
