package FoodApp::Schema::Result::TableOrder;

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

FoodApp::Schema::Result::TableOrder

=cut

__PACKAGE__->table("table_order");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 date

  data_type: 'datetime'
  is_nullable: 1

=head2 amount_paid

  data_type: 'money'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "date",
  { data_type => "datetime", is_nullable => 1 },
  "amount_paid",
  { data_type => "money", is_nullable => 1 },
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
  { "foreign.order_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-10-29 11:26:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hY7/3QcNLaWZsWL6gYGuGQ


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
