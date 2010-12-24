package FoodApp::Schema::Result::OrdersItem;

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

FoodApp::Schema::Result::OrdersItem

=cut

__PACKAGE__->table("orders_item");

=head1 ACCESSORS

=head2 order_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 item

  data_type: 'char'
  is_nullable: 0
  size: 64

=cut

__PACKAGE__->add_columns(
  "order_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "item",
  { data_type => "char", is_nullable => 0, size => 64 },
);
__PACKAGE__->set_primary_key("order_id", "item");

=head1 RELATIONS

=head2 order

Type: belongs_to

Related object: L<FoodApp::Schema::Result::Order>

=cut

__PACKAGE__->belongs_to(
  "order",
  "FoodApp::Schema::Result::Order",
  { id => "order_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-12-22 10:47:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IdL/Vxpv7dU7Z2ZfHY5gtQ


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
