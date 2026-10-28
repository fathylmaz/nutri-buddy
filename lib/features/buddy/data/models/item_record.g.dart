// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetItemRecordCollection on Isar {
  IsarCollection<ItemRecord> get itemRecords => this.collection();
}

const ItemRecordSchema = CollectionSchema(
  name: r'ItemRecord',
  id: 5908649697578126742,
  properties: {
    r'active': PropertySchema(id: 0, name: r'active', type: IsarType.bool),
    r'assetKey': PropertySchema(
      id: 1,
      name: r'assetKey',
      type: IsarType.string,
    ),
    r'goldPrice': PropertySchema(
      id: 2,
      name: r'goldPrice',
      type: IsarType.long,
    ),
    r'name': PropertySchema(id: 3, name: r'name', type: IsarType.string),
    r'recordId': PropertySchema(
      id: 4,
      name: r'recordId',
      type: IsarType.string,
    ),
    r'sku': PropertySchema(id: 5, name: r'sku', type: IsarType.string),
    r'slot': PropertySchema(id: 6, name: r'slot', type: IsarType.string),
  },

  estimateSize: _itemRecordEstimateSize,
  serialize: _itemRecordSerialize,
  deserialize: _itemRecordDeserialize,
  deserializeProp: _itemRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'recordId': IndexSchema(
      id: 907839981883940929,
      name: r'recordId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'recordId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'sku': IndexSchema(
      id: -3348042439688860591,
      name: r'sku',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sku',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _itemRecordGetId,
  getLinks: _itemRecordGetLinks,
  attach: _itemRecordAttach,
  version: '3.4.1',
);

int _itemRecordEstimateSize(
  ItemRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.assetKey.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.recordId.length * 3;
  bytesCount += 3 + object.sku.length * 3;
  bytesCount += 3 + object.slot.length * 3;
  return bytesCount;
}

void _itemRecordSerialize(
  ItemRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.active);
  writer.writeString(offsets[1], object.assetKey);
  writer.writeLong(offsets[2], object.goldPrice);
  writer.writeString(offsets[3], object.name);
  writer.writeString(offsets[4], object.recordId);
  writer.writeString(offsets[5], object.sku);
  writer.writeString(offsets[6], object.slot);
}

ItemRecord _itemRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ItemRecord();
  object.active = reader.readBool(offsets[0]);
  object.assetKey = reader.readString(offsets[1]);
  object.goldPrice = reader.readLong(offsets[2]);
  object.id = id;
  object.name = reader.readString(offsets[3]);
  object.recordId = reader.readString(offsets[4]);
  object.sku = reader.readString(offsets[5]);
  object.slot = reader.readString(offsets[6]);
  return object;
}

P _itemRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _itemRecordGetId(ItemRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _itemRecordGetLinks(ItemRecord object) {
  return [];
}

void _itemRecordAttach(IsarCollection<dynamic> col, Id id, ItemRecord object) {
  object.id = id;
}

extension ItemRecordByIndex on IsarCollection<ItemRecord> {
  Future<ItemRecord?> getByRecordId(String recordId) {
    return getByIndex(r'recordId', [recordId]);
  }

  ItemRecord? getByRecordIdSync(String recordId) {
    return getByIndexSync(r'recordId', [recordId]);
  }

  Future<bool> deleteByRecordId(String recordId) {
    return deleteByIndex(r'recordId', [recordId]);
  }

  bool deleteByRecordIdSync(String recordId) {
    return deleteByIndexSync(r'recordId', [recordId]);
  }

  Future<List<ItemRecord?>> getAllByRecordId(List<String> recordIdValues) {
    final values = recordIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'recordId', values);
  }

  List<ItemRecord?> getAllByRecordIdSync(List<String> recordIdValues) {
    final values = recordIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'recordId', values);
  }

  Future<int> deleteAllByRecordId(List<String> recordIdValues) {
    final values = recordIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'recordId', values);
  }

  int deleteAllByRecordIdSync(List<String> recordIdValues) {
    final values = recordIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'recordId', values);
  }

  Future<Id> putByRecordId(ItemRecord object) {
    return putByIndex(r'recordId', object);
  }

  Id putByRecordIdSync(ItemRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'recordId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRecordId(List<ItemRecord> objects) {
    return putAllByIndex(r'recordId', objects);
  }

  List<Id> putAllByRecordIdSync(
    List<ItemRecord> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'recordId', objects, saveLinks: saveLinks);
  }

  Future<ItemRecord?> getBySku(String sku) {
    return getByIndex(r'sku', [sku]);
  }

  ItemRecord? getBySkuSync(String sku) {
    return getByIndexSync(r'sku', [sku]);
  }

  Future<bool> deleteBySku(String sku) {
    return deleteByIndex(r'sku', [sku]);
  }

  bool deleteBySkuSync(String sku) {
    return deleteByIndexSync(r'sku', [sku]);
  }

  Future<List<ItemRecord?>> getAllBySku(List<String> skuValues) {
    final values = skuValues.map((e) => [e]).toList();
    return getAllByIndex(r'sku', values);
  }

  List<ItemRecord?> getAllBySkuSync(List<String> skuValues) {
    final values = skuValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'sku', values);
  }

  Future<int> deleteAllBySku(List<String> skuValues) {
    final values = skuValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'sku', values);
  }

  int deleteAllBySkuSync(List<String> skuValues) {
    final values = skuValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'sku', values);
  }

  Future<Id> putBySku(ItemRecord object) {
    return putByIndex(r'sku', object);
  }

  Id putBySkuSync(ItemRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'sku', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllBySku(List<ItemRecord> objects) {
    return putAllByIndex(r'sku', objects);
  }

  List<Id> putAllBySkuSync(List<ItemRecord> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'sku', objects, saveLinks: saveLinks);
  }
}

extension ItemRecordQueryWhereSort
    on QueryBuilder<ItemRecord, ItemRecord, QWhere> {
  QueryBuilder<ItemRecord, ItemRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ItemRecordQueryWhere
    on QueryBuilder<ItemRecord, ItemRecord, QWhereClause> {
  QueryBuilder<ItemRecord, ItemRecord, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterWhereClause> recordIdEqualTo(
    String recordId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'recordId', value: [recordId]),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterWhereClause> recordIdNotEqualTo(
    String recordId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'recordId',
                lower: [],
                upper: [recordId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'recordId',
                lower: [recordId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'recordId',
                lower: [recordId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'recordId',
                lower: [],
                upper: [recordId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterWhereClause> skuEqualTo(
    String sku,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'sku', value: [sku]),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterWhereClause> skuNotEqualTo(
    String sku,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'sku',
                lower: [],
                upper: [sku],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'sku',
                lower: [sku],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'sku',
                lower: [sku],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'sku',
                lower: [],
                upper: [sku],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension ItemRecordQueryFilter
    on QueryBuilder<ItemRecord, ItemRecord, QFilterCondition> {
  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> activeEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'active', value: value),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> assetKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'assetKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition>
  assetKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'assetKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> assetKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'assetKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> assetKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'assetKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition>
  assetKeyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'assetKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> assetKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'assetKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> assetKeyContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'assetKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> assetKeyMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'assetKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition>
  assetKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'assetKey', value: ''),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition>
  assetKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'assetKey', value: ''),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> goldPriceEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'goldPrice', value: value),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition>
  goldPriceGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'goldPrice',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> goldPriceLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'goldPrice',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> goldPriceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'goldPrice',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> recordIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'recordId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition>
  recordIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'recordId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> recordIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'recordId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> recordIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'recordId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition>
  recordIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'recordId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> recordIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'recordId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> recordIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'recordId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> recordIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'recordId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition>
  recordIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'recordId', value: ''),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition>
  recordIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'recordId', value: ''),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> skuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> skuGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> skuLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> skuBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sku',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> skuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'sku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> skuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'sku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> skuContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'sku',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> skuMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'sku',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> skuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sku', value: ''),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> skuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'sku', value: ''),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> slotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'slot',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> slotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'slot',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> slotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'slot',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> slotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'slot',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> slotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'slot',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> slotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'slot',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> slotContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'slot',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> slotMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'slot',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> slotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'slot', value: ''),
      );
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterFilterCondition> slotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'slot', value: ''),
      );
    });
  }
}

extension ItemRecordQueryObject
    on QueryBuilder<ItemRecord, ItemRecord, QFilterCondition> {}

extension ItemRecordQueryLinks
    on QueryBuilder<ItemRecord, ItemRecord, QFilterCondition> {}

extension ItemRecordQuerySortBy
    on QueryBuilder<ItemRecord, ItemRecord, QSortBy> {
  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> sortByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.asc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> sortByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.desc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> sortByAssetKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetKey', Sort.asc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> sortByAssetKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetKey', Sort.desc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> sortByGoldPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goldPrice', Sort.asc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> sortByGoldPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goldPrice', Sort.desc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> sortByRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.asc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> sortByRecordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.desc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> sortBySku() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sku', Sort.asc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> sortBySkuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sku', Sort.desc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> sortBySlot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot', Sort.asc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> sortBySlotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot', Sort.desc);
    });
  }
}

extension ItemRecordQuerySortThenBy
    on QueryBuilder<ItemRecord, ItemRecord, QSortThenBy> {
  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> thenByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.asc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> thenByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.desc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> thenByAssetKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetKey', Sort.asc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> thenByAssetKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assetKey', Sort.desc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> thenByGoldPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goldPrice', Sort.asc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> thenByGoldPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'goldPrice', Sort.desc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> thenByRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.asc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> thenByRecordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.desc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> thenBySku() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sku', Sort.asc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> thenBySkuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sku', Sort.desc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> thenBySlot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot', Sort.asc);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QAfterSortBy> thenBySlotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot', Sort.desc);
    });
  }
}

extension ItemRecordQueryWhereDistinct
    on QueryBuilder<ItemRecord, ItemRecord, QDistinct> {
  QueryBuilder<ItemRecord, ItemRecord, QDistinct> distinctByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'active');
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QDistinct> distinctByAssetKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assetKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QDistinct> distinctByGoldPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'goldPrice');
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QDistinct> distinctByRecordId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recordId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QDistinct> distinctBySku({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sku', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ItemRecord, ItemRecord, QDistinct> distinctBySlot({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slot', caseSensitive: caseSensitive);
    });
  }
}

extension ItemRecordQueryProperty
    on QueryBuilder<ItemRecord, ItemRecord, QQueryProperty> {
  QueryBuilder<ItemRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ItemRecord, bool, QQueryOperations> activeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'active');
    });
  }

  QueryBuilder<ItemRecord, String, QQueryOperations> assetKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assetKey');
    });
  }

  QueryBuilder<ItemRecord, int, QQueryOperations> goldPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'goldPrice');
    });
  }

  QueryBuilder<ItemRecord, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<ItemRecord, String, QQueryOperations> recordIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recordId');
    });
  }

  QueryBuilder<ItemRecord, String, QQueryOperations> skuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sku');
    });
  }

  QueryBuilder<ItemRecord, String, QQueryOperations> slotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slot');
    });
  }
}
