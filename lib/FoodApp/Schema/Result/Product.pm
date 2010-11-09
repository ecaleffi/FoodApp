package FoodApp::Schema::Result::Product;

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

FoodApp::Schema::Result::Product

=cut

__PACKAGE__->table("product");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'char'
  is_nullable: 1
  size: 64

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 price

  data_type: 'money'
  is_nullable: 1

=head2 duration

  data_type: 'date'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "char", is_nullable => 1, size => 64 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "price",
  { data_type => "money", is_nullable => 1 },
  "duration",
  { data_type => "date", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 contain

Type: might_have

Related object: L<FoodApp::Schema::Result::Contain>

=cut

__PACKAGE__->might_have(
  "contain",
  "FoodApp::Schema::Result::Contain",
  { "foreign.product_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 produce

Type: might_have

Related object: L<FoodApp::Schema::Result::Produce>

=cut

__PACKAGE__->might_have(
  "produce",
  "FoodApp::Schema::Result::Produce",
  { "foreign.product_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 have_a

Type: might_have

Related object: L<FoodApp::Schema::Result::HaveA>

=cut

__PACKAGE__->might_have(
  "have_a",
  "FoodApp::Schema::Result::HaveA",
  { "foreign.product_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 product_tags

Type: has_many

Related object: L<FoodApp::Schema::Result::ProductTag>

=cut

__PACKAGE__->has_many(
  "product_tags",
  "FoodApp::Schema::Result::ProductTag",
  { "foreign.product_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2010-11-02 13:31:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tz6oVWm5AOGMF00DZNJCKg

__PACKAGE__->many_to_many(tags => 'product_tags', 'tag');

# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
