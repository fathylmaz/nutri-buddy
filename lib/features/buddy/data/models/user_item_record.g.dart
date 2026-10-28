// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_item_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetUserItemRecordCollection on Isar {
  IsarCollection<UserItemRecord> get userItemRecords => this.collection();
}

const UserItemRecordSchema = CollectionSchema(
  name: r'UserItemRecord',
  id: -1510407268431777701,
  properties: {
    r'acquiredAt': PropertySchema(
      id: 0,
      name: r'acquiredAt',
      type: IsarType.dateTime,
    ),
    r'equipped': PropertySchema(id: 1, name: r'equipped', type: IsarType.bool),
    r'itemId': PropertySchema(id: 2, name: r'itemId', type: IsarType.string),
    r'recordId': PropertySchema(
      id: 3,
      name: r'recordId',
      type: IsarType.string,
    ),
    r'userId': PropertySchema(id: 4, name: r'userId', type: IsarType.string),
  },

  estimateSize: _userItemRecordEstimateSize,
  serialize: _userItemRecordSerialize,
  deserialize: _userItemRecordDeserialize,
  deserializeProp: _userItemRecordDeserializeProp,
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
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _userItemRecordGetId,
  getLinks: _userItemRecordGetLinks,
  attach: _userItemRecordAttach,
  version: '3.4.1',
);

int _userItemRecordEstimateSize(
  UserItemRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.itemId.length * 3;
  bytesCount += 3 + object.recordId.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _userItemRecordSerialize(
  UserItemRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.acquiredAt);
  writer.writeBool(offsets[1], object.equipped);
  writer.writeString(offsets[2], object.itemId);
  writer.writeString(offsets[3], object.recordId);
  writer.writeString(offsets[4], object.userId);
}

UserItemRecord _userItemRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserItemRecord();
  object.acquiredAt = reader.readDateTime(offsets[0]);
  object.equipped = reader.readBool(offsets[1]);
  object.id = id;
  object.itemId = reader.readString(offsets[2]);
  object.recordId = reader.readString(offsets[3]);
  object.userId = reader.readString(offsets[4]);
  return object;
}

P _userItemRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userItemRecordGetId(UserItemRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userItemRecordGetLinks(UserItemRecord object) {
  return [];
}

void _userItemRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  UserItemRecord object,
) {
  object.id = id;
}

extension UserItemRecordByIndex on IsarCollection<UserItemRecord> {
  Future<UserItemRecord?> getByRecordId(String recordId) {
    return getByIndex(r'recordId', [recordId]);
  }

  UserItemRecord? getByRecordIdSync(String recordId) {
    return getByIndexSync(r'recordId', [recordId]);
  }

  Future<bool> deleteByRecordId(String recordId) {
    return deleteByIndex(r'recordId', [recordId]);
  }

  bool deleteByRecordIdSync(String recordId) {
    return deleteByIndexSync(r'recordId', [recordId]);
  }

  Future<List<UserItemRecord?>> getAllByRecordId(List<String> recordIdValues) {
    final values = recordIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'recordId', values);
  }

  List<UserItemRecord?> getAllByRecordIdSync(List<String> recordIdValues) {
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

  Future<Id> putByRecordId(UserItemRecord object) {
    return putByIndex(r'recordId', object);
  }

  Id putByRecordIdSync(UserItemRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'recordId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRecordId(List<UserItemRecord> objects) {
    return putAllByIndex(r'recordId', objects);
  }

  List<Id> putAllByRecordIdSync(
    List<UserItemRecord> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'recordId', objects, saveLinks: saveLinks);
  }
}

extension UserItemRecordQueryWhereSort
    on QueryBuilder<UserItemRecord, UserItemRecord, QWhere> {
  QueryBuilder<UserItemRecord, UserItemRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserItemRecordQueryWhere
    on QueryBuilder<UserItemRecord, UserItemRecord, QWhereClause> {
  QueryBuilder<UserItemRecord, UserItemRecord, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterWhereClause> idBetween(
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

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterWhereClause>
  recordIdEqualTo(String recordId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'recordId', value: [recordId]),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterWhereClause>
  recordIdNotEqualTo(String recordId) {
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

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterWhereClause> userIdEqualTo(
    String userId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'userId', value: [userId]),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterWhereClause>
  userIdNotEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId',
                lower: [],
                upper: [userId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId',
                lower: [userId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId',
                lower: [userId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId',
                lower: [],
                upper: [userId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension UserItemRecordQueryFilter
    on QueryBuilder<UserItemRecord, UserItemRecord, QFilterCondition> {
  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  acquiredAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'acquiredAt', value: value),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  acquiredAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'acquiredAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  acquiredAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'acquiredAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  acquiredAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'acquiredAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  equippedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'equipped', value: value),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
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

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  itemIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'itemId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  itemIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'itemId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  itemIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'itemId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  itemIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'itemId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  itemIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'itemId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  itemIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'itemId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  itemIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'itemId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  itemIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'itemId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  itemIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'itemId', value: ''),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  itemIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'itemId', value: ''),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  recordIdEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
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

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  recordIdLessThan(
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

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  recordIdBetween(
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

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
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

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  recordIdEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  recordIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  recordIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  recordIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'recordId', value: ''),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  recordIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'recordId', value: ''),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  userIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'userId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  userIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  userIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'userId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userId', value: ''),
      );
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterFilterCondition>
  userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'userId', value: ''),
      );
    });
  }
}

extension UserItemRecordQueryObject
    on QueryBuilder<UserItemRecord, UserItemRecord, QFilterCondition> {}

extension UserItemRecordQueryLinks
    on QueryBuilder<UserItemRecord, UserItemRecord, QFilterCondition> {}

extension UserItemRecordQuerySortBy
    on QueryBuilder<UserItemRecord, UserItemRecord, QSortBy> {
  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy>
  sortByAcquiredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'acquiredAt', Sort.asc);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy>
  sortByAcquiredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'acquiredAt', Sort.desc);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy> sortByEquipped() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'equipped', Sort.asc);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy>
  sortByEquippedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'equipped', Sort.desc);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy> sortByItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.asc);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy>
  sortByItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.desc);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy> sortByRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.asc);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy>
  sortByRecordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.desc);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy>
  sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension UserItemRecordQuerySortThenBy
    on QueryBuilder<UserItemRecord, UserItemRecord, QSortThenBy> {
  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy>
  thenByAcquiredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'acquiredAt', Sort.asc);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy>
  thenByAcquiredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'acquiredAt', Sort.desc);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy> thenByEquipped() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'equipped', Sort.asc);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy>
  thenByEquippedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'equipped', Sort.desc);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy> thenByItemId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.asc);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy>
  thenByItemIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemId', Sort.desc);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy> thenByRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.asc);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy>
  thenByRecordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.desc);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QAfterSortBy>
  thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension UserItemRecordQueryWhereDistinct
    on QueryBuilder<UserItemRecord, UserItemRecord, QDistinct> {
  QueryBuilder<UserItemRecord, UserItemRecord, QDistinct>
  distinctByAcquiredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'acquiredAt');
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QDistinct> distinctByEquipped() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'equipped');
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QDistinct> distinctByItemId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QDistinct> distinctByRecordId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recordId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserItemRecord, UserItemRecord, QDistinct> distinctByUserId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension UserItemRecordQueryProperty
    on QueryBuilder<UserItemRecord, UserItemRecord, QQueryProperty> {
  QueryBuilder<UserItemRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserItemRecord, DateTime, QQueryOperations>
  acquiredAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'acquiredAt');
    });
  }

  QueryBuilder<UserItemRecord, bool, QQueryOperations> equippedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'equipped');
    });
  }

  QueryBuilder<UserItemRecord, String, QQueryOperations> itemIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemId');
    });
  }

  QueryBuilder<UserItemRecord, String, QQueryOperations> recordIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recordId');
    });
  }

  QueryBuilder<UserItemRecord, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
