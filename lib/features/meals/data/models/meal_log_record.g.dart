// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_log_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetMealLogRecordCollection on Isar {
  IsarCollection<MealLogRecord> get mealLogRecords => this.collection();
}

const MealLogRecordSchema = CollectionSchema(
  name: r'MealLogRecord',
  id: 2013303346504034113,
  properties: {
    r'caloriesKcal': PropertySchema(
      id: 0,
      name: r'caloriesKcal',
      type: IsarType.long,
    ),
    r'carbsG': PropertySchema(id: 1, name: r'carbsG', type: IsarType.double),
    r'fatG': PropertySchema(id: 2, name: r'fatG', type: IsarType.double),
    r'fiberG': PropertySchema(id: 3, name: r'fiberG', type: IsarType.double),
    r'isDeleted': PropertySchema(
      id: 4,
      name: r'isDeleted',
      type: IsarType.bool,
    ),
    r'isEstimate': PropertySchema(
      id: 5,
      name: r'isEstimate',
      type: IsarType.bool,
    ),
    r'loggedAt': PropertySchema(
      id: 6,
      name: r'loggedAt',
      type: IsarType.dateTime,
    ),
    r'mealType': PropertySchema(
      id: 7,
      name: r'mealType',
      type: IsarType.string,
    ),
    r'name': PropertySchema(id: 8, name: r'name', type: IsarType.string),
    r'pendingSync': PropertySchema(
      id: 9,
      name: r'pendingSync',
      type: IsarType.bool,
    ),
    r'proteinG': PropertySchema(
      id: 10,
      name: r'proteinG',
      type: IsarType.double,
    ),
    r'recipeDetailsJson': PropertySchema(
      id: 11,
      name: r'recipeDetailsJson',
      type: IsarType.string,
    ),
    r'recordId': PropertySchema(
      id: 12,
      name: r'recordId',
      type: IsarType.string,
    ),
    r'serverRevision': PropertySchema(
      id: 13,
      name: r'serverRevision',
      type: IsarType.long,
    ),
    r'source': PropertySchema(id: 14, name: r'source', type: IsarType.string),
    r'updatedAt': PropertySchema(
      id: 15,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(id: 16, name: r'userId', type: IsarType.string),
    r'visionDetailsJson': PropertySchema(
      id: 17,
      name: r'visionDetailsJson',
      type: IsarType.string,
    ),
  },

  estimateSize: _mealLogRecordEstimateSize,
  serialize: _mealLogRecordSerialize,
  deserialize: _mealLogRecordDeserialize,
  deserializeProp: _mealLogRecordDeserializeProp,
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

  getId: _mealLogRecordGetId,
  getLinks: _mealLogRecordGetLinks,
  attach: _mealLogRecordAttach,
  version: '3.4.1',
);

int _mealLogRecordEstimateSize(
  MealLogRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.mealType.length * 3;
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.recipeDetailsJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.recordId.length * 3;
  bytesCount += 3 + object.source.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  {
    final value = object.visionDetailsJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _mealLogRecordSerialize(
  MealLogRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.caloriesKcal);
  writer.writeDouble(offsets[1], object.carbsG);
  writer.writeDouble(offsets[2], object.fatG);
  writer.writeDouble(offsets[3], object.fiberG);
  writer.writeBool(offsets[4], object.isDeleted);
  writer.writeBool(offsets[5], object.isEstimate);
  writer.writeDateTime(offsets[6], object.loggedAt);
  writer.writeString(offsets[7], object.mealType);
  writer.writeString(offsets[8], object.name);
  writer.writeBool(offsets[9], object.pendingSync);
  writer.writeDouble(offsets[10], object.proteinG);
  writer.writeString(offsets[11], object.recipeDetailsJson);
  writer.writeString(offsets[12], object.recordId);
  writer.writeLong(offsets[13], object.serverRevision);
  writer.writeString(offsets[14], object.source);
  writer.writeDateTime(offsets[15], object.updatedAt);
  writer.writeString(offsets[16], object.userId);
  writer.writeString(offsets[17], object.visionDetailsJson);
}

MealLogRecord _mealLogRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MealLogRecord();
  object.caloriesKcal = reader.readLong(offsets[0]);
  object.carbsG = reader.readDouble(offsets[1]);
  object.fatG = reader.readDouble(offsets[2]);
  object.fiberG = reader.readDouble(offsets[3]);
  object.id = id;
  object.isDeleted = reader.readBool(offsets[4]);
  object.isEstimate = reader.readBool(offsets[5]);
  object.loggedAt = reader.readDateTime(offsets[6]);
  object.mealType = reader.readString(offsets[7]);
  object.name = reader.readString(offsets[8]);
  object.pendingSync = reader.readBool(offsets[9]);
  object.proteinG = reader.readDouble(offsets[10]);
  object.recipeDetailsJson = reader.readStringOrNull(offsets[11]);
  object.recordId = reader.readString(offsets[12]);
  object.serverRevision = reader.readLong(offsets[13]);
  object.source = reader.readString(offsets[14]);
  object.updatedAt = reader.readDateTime(offsets[15]);
  object.userId = reader.readString(offsets[16]);
  object.visionDetailsJson = reader.readStringOrNull(offsets[17]);
  return object;
}

P _mealLogRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readDateTime(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _mealLogRecordGetId(MealLogRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mealLogRecordGetLinks(MealLogRecord object) {
  return [];
}

void _mealLogRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  MealLogRecord object,
) {
  object.id = id;
}

extension MealLogRecordByIndex on IsarCollection<MealLogRecord> {
  Future<MealLogRecord?> getByRecordId(String recordId) {
    return getByIndex(r'recordId', [recordId]);
  }

  MealLogRecord? getByRecordIdSync(String recordId) {
    return getByIndexSync(r'recordId', [recordId]);
  }

  Future<bool> deleteByRecordId(String recordId) {
    return deleteByIndex(r'recordId', [recordId]);
  }

  bool deleteByRecordIdSync(String recordId) {
    return deleteByIndexSync(r'recordId', [recordId]);
  }

  Future<List<MealLogRecord?>> getAllByRecordId(List<String> recordIdValues) {
    final values = recordIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'recordId', values);
  }

  List<MealLogRecord?> getAllByRecordIdSync(List<String> recordIdValues) {
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

  Future<Id> putByRecordId(MealLogRecord object) {
    return putByIndex(r'recordId', object);
  }

  Id putByRecordIdSync(MealLogRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'recordId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRecordId(List<MealLogRecord> objects) {
    return putAllByIndex(r'recordId', objects);
  }

  List<Id> putAllByRecordIdSync(
    List<MealLogRecord> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'recordId', objects, saveLinks: saveLinks);
  }
}

extension MealLogRecordQueryWhereSort
    on QueryBuilder<MealLogRecord, MealLogRecord, QWhere> {
  QueryBuilder<MealLogRecord, MealLogRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MealLogRecordQueryWhere
    on QueryBuilder<MealLogRecord, MealLogRecord, QWhereClause> {
  QueryBuilder<MealLogRecord, MealLogRecord, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterWhereClause> idBetween(
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterWhereClause> recordIdEqualTo(
    String recordId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'recordId', value: [recordId]),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterWhereClause>
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterWhereClause> userIdEqualTo(
    String userId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'userId', value: [userId]),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterWhereClause>
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

extension MealLogRecordQueryFilter
    on QueryBuilder<MealLogRecord, MealLogRecord, QFilterCondition> {
  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  caloriesKcalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'caloriesKcal', value: value),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  caloriesKcalGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'caloriesKcal',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  caloriesKcalLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'caloriesKcal',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  caloriesKcalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'caloriesKcal',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  carbsGEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'carbsG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  carbsGGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'carbsG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  carbsGLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'carbsG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  carbsGBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'carbsG',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition> fatGEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'fatG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  fatGGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fatG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  fatGLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fatG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition> fatGBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fatG',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  fiberGEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'fiberG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  fiberGGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fiberG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  fiberGLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fiberG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  fiberGBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fiberG',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  isDeletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isDeleted', value: value),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  isEstimateEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isEstimate', value: value),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  loggedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'loggedAt', value: value),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  loggedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'loggedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  loggedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'loggedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  loggedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'loggedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  mealTypeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'mealType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  mealTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mealType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  mealTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mealType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  mealTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mealType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  mealTypeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'mealType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  mealTypeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'mealType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  mealTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'mealType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  mealTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'mealType',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  mealTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mealType', value: ''),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  mealTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'mealType', value: ''),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  nameGreaterThan(
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  nameLessThan(
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  nameStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  nameEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  nameContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  pendingSyncEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'pendingSync', value: value),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  proteinGEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'proteinG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  proteinGGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'proteinG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  proteinGLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'proteinG',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  proteinGBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'proteinG',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  recipeDetailsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'recipeDetailsJson'),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  recipeDetailsJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'recipeDetailsJson'),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  recipeDetailsJsonEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'recipeDetailsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  recipeDetailsJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'recipeDetailsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  recipeDetailsJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'recipeDetailsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  recipeDetailsJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'recipeDetailsJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  recipeDetailsJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'recipeDetailsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  recipeDetailsJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'recipeDetailsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  recipeDetailsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'recipeDetailsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  recipeDetailsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'recipeDetailsJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  recipeDetailsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'recipeDetailsJson', value: ''),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  recipeDetailsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'recipeDetailsJson', value: ''),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  recordIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'recordId', value: ''),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  recordIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'recordId', value: ''),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  serverRevisionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'serverRevision', value: value),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  serverRevisionGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'serverRevision',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  serverRevisionLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'serverRevision',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  serverRevisionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'serverRevision',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  sourceEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  sourceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  sourceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  sourceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'source',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  sourceStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  sourceEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  sourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'source',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  sourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'source',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'source', value: ''),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'source', value: ''),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  updatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
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

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userId', value: ''),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'userId', value: ''),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  visionDetailsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'visionDetailsJson'),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  visionDetailsJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'visionDetailsJson'),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  visionDetailsJsonEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'visionDetailsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  visionDetailsJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'visionDetailsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  visionDetailsJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'visionDetailsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  visionDetailsJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'visionDetailsJson',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  visionDetailsJsonStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'visionDetailsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  visionDetailsJsonEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'visionDetailsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  visionDetailsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'visionDetailsJson',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  visionDetailsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'visionDetailsJson',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  visionDetailsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'visionDetailsJson', value: ''),
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterFilterCondition>
  visionDetailsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'visionDetailsJson', value: ''),
      );
    });
  }
}

extension MealLogRecordQueryObject
    on QueryBuilder<MealLogRecord, MealLogRecord, QFilterCondition> {}

extension MealLogRecordQueryLinks
    on QueryBuilder<MealLogRecord, MealLogRecord, QFilterCondition> {}

extension MealLogRecordQuerySortBy
    on QueryBuilder<MealLogRecord, MealLogRecord, QSortBy> {
  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  sortByCaloriesKcal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'caloriesKcal', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  sortByCaloriesKcalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'caloriesKcal', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> sortByCarbsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbsG', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> sortByCarbsGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbsG', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> sortByFatG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatG', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> sortByFatGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatG', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> sortByFiberG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiberG', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> sortByFiberGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiberG', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> sortByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  sortByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> sortByIsEstimate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEstimate', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  sortByIsEstimateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEstimate', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> sortByLoggedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loggedAt', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  sortByLoggedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loggedAt', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> sortByMealType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealType', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  sortByMealTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealType', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> sortByPendingSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingSync', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  sortByPendingSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingSync', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> sortByProteinG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinG', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  sortByProteinGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinG', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  sortByRecipeDetailsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipeDetailsJson', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  sortByRecipeDetailsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipeDetailsJson', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> sortByRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  sortByRecordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  sortByServerRevision() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverRevision', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  sortByServerRevisionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverRevision', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  sortByVisionDetailsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visionDetailsJson', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  sortByVisionDetailsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visionDetailsJson', Sort.desc);
    });
  }
}

extension MealLogRecordQuerySortThenBy
    on QueryBuilder<MealLogRecord, MealLogRecord, QSortThenBy> {
  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  thenByCaloriesKcal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'caloriesKcal', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  thenByCaloriesKcalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'caloriesKcal', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenByCarbsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbsG', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenByCarbsGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbsG', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenByFatG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatG', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenByFatGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fatG', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenByFiberG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiberG', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenByFiberGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiberG', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  thenByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenByIsEstimate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEstimate', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  thenByIsEstimateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEstimate', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenByLoggedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loggedAt', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  thenByLoggedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loggedAt', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenByMealType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealType', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  thenByMealTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealType', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenByPendingSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingSync', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  thenByPendingSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingSync', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenByProteinG() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinG', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  thenByProteinGDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proteinG', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  thenByRecipeDetailsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipeDetailsJson', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  thenByRecipeDetailsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recipeDetailsJson', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenByRecordId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  thenByRecordIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recordId', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  thenByServerRevision() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverRevision', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  thenByServerRevisionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'serverRevision', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  thenByVisionDetailsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visionDetailsJson', Sort.asc);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QAfterSortBy>
  thenByVisionDetailsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visionDetailsJson', Sort.desc);
    });
  }
}

extension MealLogRecordQueryWhereDistinct
    on QueryBuilder<MealLogRecord, MealLogRecord, QDistinct> {
  QueryBuilder<MealLogRecord, MealLogRecord, QDistinct>
  distinctByCaloriesKcal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'caloriesKcal');
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QDistinct> distinctByCarbsG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'carbsG');
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QDistinct> distinctByFatG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fatG');
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QDistinct> distinctByFiberG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fiberG');
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QDistinct> distinctByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDeleted');
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QDistinct> distinctByIsEstimate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isEstimate');
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QDistinct> distinctByLoggedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'loggedAt');
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QDistinct> distinctByMealType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mealType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QDistinct>
  distinctByPendingSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pendingSync');
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QDistinct> distinctByProteinG() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proteinG');
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QDistinct>
  distinctByRecipeDetailsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'recipeDetailsJson',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QDistinct> distinctByRecordId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recordId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QDistinct>
  distinctByServerRevision() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'serverRevision');
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QDistinct> distinctBySource({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QDistinct> distinctByUserId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MealLogRecord, MealLogRecord, QDistinct>
  distinctByVisionDetailsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'visionDetailsJson',
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension MealLogRecordQueryProperty
    on QueryBuilder<MealLogRecord, MealLogRecord, QQueryProperty> {
  QueryBuilder<MealLogRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MealLogRecord, int, QQueryOperations> caloriesKcalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'caloriesKcal');
    });
  }

  QueryBuilder<MealLogRecord, double, QQueryOperations> carbsGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carbsG');
    });
  }

  QueryBuilder<MealLogRecord, double, QQueryOperations> fatGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fatG');
    });
  }

  QueryBuilder<MealLogRecord, double, QQueryOperations> fiberGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fiberG');
    });
  }

  QueryBuilder<MealLogRecord, bool, QQueryOperations> isDeletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDeleted');
    });
  }

  QueryBuilder<MealLogRecord, bool, QQueryOperations> isEstimateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isEstimate');
    });
  }

  QueryBuilder<MealLogRecord, DateTime, QQueryOperations> loggedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'loggedAt');
    });
  }

  QueryBuilder<MealLogRecord, String, QQueryOperations> mealTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mealType');
    });
  }

  QueryBuilder<MealLogRecord, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<MealLogRecord, bool, QQueryOperations> pendingSyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pendingSync');
    });
  }

  QueryBuilder<MealLogRecord, double, QQueryOperations> proteinGProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proteinG');
    });
  }

  QueryBuilder<MealLogRecord, String?, QQueryOperations>
  recipeDetailsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recipeDetailsJson');
    });
  }

  QueryBuilder<MealLogRecord, String, QQueryOperations> recordIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recordId');
    });
  }

  QueryBuilder<MealLogRecord, int, QQueryOperations> serverRevisionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'serverRevision');
    });
  }

  QueryBuilder<MealLogRecord, String, QQueryOperations> sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<MealLogRecord, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<MealLogRecord, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<MealLogRecord, String?, QQueryOperations>
  visionDetailsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'visionDetailsJson');
    });
  }
}
