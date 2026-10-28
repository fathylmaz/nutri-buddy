// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_mutation_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetPendingMutationRecordCollection on Isar {
  IsarCollection<PendingMutationRecord> get pendingMutationRecords =>
      this.collection();
}

const PendingMutationRecordSchema = CollectionSchema(
  name: r'PendingMutationRecord',
  id: -2730789602306178371,
  properties: {
    r'entityId': PropertySchema(
      id: 0,
      name: r'entityId',
      type: IsarType.string,
    ),
    r'entityType': PropertySchema(
      id: 1,
      name: r'entityType',
      type: IsarType.string,
    ),
    r'operation': PropertySchema(
      id: 2,
      name: r'operation',
      type: IsarType.string,
    ),
    r'queuedAt': PropertySchema(
      id: 3,
      name: r'queuedAt',
      type: IsarType.dateTime,
    ),
    r'retryAfter': PropertySchema(
      id: 4,
      name: r'retryAfter',
      type: IsarType.dateTime,
    ),
    r'retryCount': PropertySchema(
      id: 5,
      name: r'retryCount',
      type: IsarType.long,
    ),
    r'userId': PropertySchema(id: 6, name: r'userId', type: IsarType.string),
  },

  estimateSize: _pendingMutationRecordEstimateSize,
  serialize: _pendingMutationRecordSerialize,
  deserialize: _pendingMutationRecordDeserialize,
  deserializeProp: _pendingMutationRecordDeserializeProp,
  idName: r'id',
  indexes: {
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

  getId: _pendingMutationRecordGetId,
  getLinks: _pendingMutationRecordGetLinks,
  attach: _pendingMutationRecordAttach,
  version: '3.4.1',
);

int _pendingMutationRecordEstimateSize(
  PendingMutationRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.entityId.length * 3;
  bytesCount += 3 + object.entityType.length * 3;
  bytesCount += 3 + object.operation.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _pendingMutationRecordSerialize(
  PendingMutationRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.entityId);
  writer.writeString(offsets[1], object.entityType);
  writer.writeString(offsets[2], object.operation);
  writer.writeDateTime(offsets[3], object.queuedAt);
  writer.writeDateTime(offsets[4], object.retryAfter);
  writer.writeLong(offsets[5], object.retryCount);
  writer.writeString(offsets[6], object.userId);
}

PendingMutationRecord _pendingMutationRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PendingMutationRecord();
  object.entityId = reader.readString(offsets[0]);
  object.entityType = reader.readString(offsets[1]);
  object.id = id;
  object.operation = reader.readString(offsets[2]);
  object.queuedAt = reader.readDateTime(offsets[3]);
  object.retryAfter = reader.readDateTimeOrNull(offsets[4]);
  object.retryCount = reader.readLong(offsets[5]);
  object.userId = reader.readString(offsets[6]);
  return object;
}

P _pendingMutationRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pendingMutationRecordGetId(PendingMutationRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pendingMutationRecordGetLinks(
  PendingMutationRecord object,
) {
  return [];
}

void _pendingMutationRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  PendingMutationRecord object,
) {
  object.id = id;
}

extension PendingMutationRecordQueryWhereSort
    on QueryBuilder<PendingMutationRecord, PendingMutationRecord, QWhere> {
  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PendingMutationRecordQueryWhere
    on
        QueryBuilder<
          PendingMutationRecord,
          PendingMutationRecord,
          QWhereClause
        > {
  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterWhereClause>
  idNotEqualTo(Id id) {
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

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterWhereClause>
  idBetween(
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

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterWhereClause>
  userIdEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'userId', value: [userId]),
      );
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterWhereClause>
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

extension PendingMutationRecordQueryFilter
    on
        QueryBuilder<
          PendingMutationRecord,
          PendingMutationRecord,
          QFilterCondition
        > {
  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  entityIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'entityId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  entityIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'entityId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  entityIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'entityId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  entityIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'entityId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  entityIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'entityId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  entityIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'entityId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  entityIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'entityId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  entityIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'entityId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  entityIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'entityId', value: ''),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  entityIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'entityId', value: ''),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  entityTypeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'entityType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  entityTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'entityType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  entityTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'entityType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  entityTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'entityType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  entityTypeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'entityType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  entityTypeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'entityType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  entityTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'entityType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  entityTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'entityType',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  entityTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'entityType', value: ''),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  entityTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'entityType', value: ''),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  idBetween(
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

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  operationEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'operation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  operationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'operation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  operationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'operation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  operationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'operation',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  operationStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'operation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  operationEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'operation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  operationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'operation',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  operationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'operation',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  operationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'operation', value: ''),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  operationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'operation', value: ''),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  queuedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'queuedAt', value: value),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  queuedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'queuedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  queuedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'queuedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  queuedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'queuedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  retryAfterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'retryAfter'),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  retryAfterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'retryAfter'),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  retryAfterEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'retryAfter', value: value),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  retryAfterGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'retryAfter',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  retryAfterLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'retryAfter',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  retryAfterBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'retryAfter',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  retryCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'retryCount', value: value),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  retryCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'retryCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  retryCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'retryCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  retryCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'retryCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userId', value: ''),
      );
    });
  }

  QueryBuilder<
    PendingMutationRecord,
    PendingMutationRecord,
    QAfterFilterCondition
  >
  userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'userId', value: ''),
      );
    });
  }
}

extension PendingMutationRecordQueryObject
    on
        QueryBuilder<
          PendingMutationRecord,
          PendingMutationRecord,
          QFilterCondition
        > {}

extension PendingMutationRecordQueryLinks
    on
        QueryBuilder<
          PendingMutationRecord,
          PendingMutationRecord,
          QFilterCondition
        > {}

extension PendingMutationRecordQuerySortBy
    on QueryBuilder<PendingMutationRecord, PendingMutationRecord, QSortBy> {
  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  sortByEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.asc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  sortByEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.desc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  sortByEntityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.asc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  sortByEntityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.desc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  sortByOperation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operation', Sort.asc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  sortByOperationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operation', Sort.desc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  sortByQueuedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queuedAt', Sort.asc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  sortByQueuedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queuedAt', Sort.desc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  sortByRetryAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryAfter', Sort.asc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  sortByRetryAfterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryAfter', Sort.desc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  sortByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.asc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  sortByRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.desc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension PendingMutationRecordQuerySortThenBy
    on QueryBuilder<PendingMutationRecord, PendingMutationRecord, QSortThenBy> {
  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  thenByEntityId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.asc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  thenByEntityIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityId', Sort.desc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  thenByEntityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.asc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  thenByEntityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entityType', Sort.desc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  thenByOperation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operation', Sort.asc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  thenByOperationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operation', Sort.desc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  thenByQueuedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queuedAt', Sort.asc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  thenByQueuedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'queuedAt', Sort.desc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  thenByRetryAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryAfter', Sort.asc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  thenByRetryAfterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryAfter', Sort.desc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  thenByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.asc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  thenByRetryCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retryCount', Sort.desc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QAfterSortBy>
  thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension PendingMutationRecordQueryWhereDistinct
    on QueryBuilder<PendingMutationRecord, PendingMutationRecord, QDistinct> {
  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QDistinct>
  distinctByEntityId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entityId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QDistinct>
  distinctByEntityType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entityType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QDistinct>
  distinctByOperation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'operation', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QDistinct>
  distinctByQueuedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'queuedAt');
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QDistinct>
  distinctByRetryAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'retryAfter');
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QDistinct>
  distinctByRetryCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'retryCount');
    });
  }

  QueryBuilder<PendingMutationRecord, PendingMutationRecord, QDistinct>
  distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension PendingMutationRecordQueryProperty
    on
        QueryBuilder<
          PendingMutationRecord,
          PendingMutationRecord,
          QQueryProperty
        > {
  QueryBuilder<PendingMutationRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PendingMutationRecord, String, QQueryOperations>
  entityIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entityId');
    });
  }

  QueryBuilder<PendingMutationRecord, String, QQueryOperations>
  entityTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entityType');
    });
  }

  QueryBuilder<PendingMutationRecord, String, QQueryOperations>
  operationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'operation');
    });
  }

  QueryBuilder<PendingMutationRecord, DateTime, QQueryOperations>
  queuedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'queuedAt');
    });
  }

  QueryBuilder<PendingMutationRecord, DateTime?, QQueryOperations>
  retryAfterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'retryAfter');
    });
  }

  QueryBuilder<PendingMutationRecord, int, QQueryOperations>
  retryCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'retryCount');
    });
  }

  QueryBuilder<PendingMutationRecord, String, QQueryOperations>
  userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
