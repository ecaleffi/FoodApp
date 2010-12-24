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

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 number

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "number",
  { data_type => "varchar", is_nullable => 1, size => 20 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 orders_items

Type: has_many

Related object: L<FoodApp::Schema::Result::OrdersItem>

=cut

__PACKAGE__->has_many(
  "orders_items",
  "FoodApp::Schema::Result::OrdersItem",
  { "foreign.order_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-12-22 11:03:55
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3MTezBi7ILL+K7tZv3N2eA


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
