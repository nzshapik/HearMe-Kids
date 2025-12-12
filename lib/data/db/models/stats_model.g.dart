// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyStatsCollection on Isar {
  IsarCollection<DailyStats> get dailyStats => this.collection();
}

const DailyStatsSchema = CollectionSchema(
  name: r'DailyStats',
  id: -7592871651347013517,
  properties: {
    r'avgScore': PropertySchema(
      id: 0,
      name: r'avgScore',
      type: IsarType.double,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'deescalationSec': PropertySchema(
      id: 2,
      name: r'deescalationSec',
      type: IsarType.long,
    ),
    r'insultsCount': PropertySchema(
      id: 3,
      name: r'insultsCount',
      type: IsarType.long,
    ),
    r'peaks': PropertySchema(
      id: 4,
      name: r'peaks',
      type: IsarType.long,
    )
  },
  estimateSize: _dailyStatsEstimateSize,
  serialize: _dailyStatsSerialize,
  deserialize: _dailyStatsDeserialize,
  deserializeProp: _dailyStatsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _dailyStatsGetId,
  getLinks: _dailyStatsGetLinks,
  attach: _dailyStatsAttach,
  version: '3.1.0+1',
);

int _dailyStatsEstimateSize(
  DailyStats object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _dailyStatsSerialize(
  DailyStats object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.avgScore);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeLong(offsets[2], object.deescalationSec);
  writer.writeLong(offsets[3], object.insultsCount);
  writer.writeLong(offsets[4], object.peaks);
}

DailyStats _dailyStatsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyStats();
  object.avgScore = reader.readDouble(offsets[0]);
  object.date = reader.readDateTime(offsets[1]);
  object.deescalationSec = reader.readLong(offsets[2]);
  object.id = id;
  object.insultsCount = reader.readLong(offsets[3]);
  object.peaks = reader.readLong(offsets[4]);
  return object;
}

P _dailyStatsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyStatsGetId(DailyStats object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyStatsGetLinks(DailyStats object) {
  return [];
}

void _dailyStatsAttach(IsarCollection<dynamic> col, Id id, DailyStats object) {
  object.id = id;
}

extension DailyStatsQueryWhereSort
    on QueryBuilder<DailyStats, DailyStats, QWhere> {
  QueryBuilder<DailyStats, DailyStats, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DailyStatsQueryWhere
    on QueryBuilder<DailyStats, DailyStats, QWhereClause> {
  QueryBuilder<DailyStats, DailyStats, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<DailyStats, DailyStats, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyStatsQueryFilter
    on QueryBuilder<DailyStats, DailyStats, QFilterCondition> {
  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition> avgScoreEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avgScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition>
      avgScoreGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avgScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition> avgScoreLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avgScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition> avgScoreBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avgScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition>
      deescalationSecEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deescalationSec',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition>
      deescalationSecGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deescalationSec',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition>
      deescalationSecLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deescalationSec',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition>
      deescalationSecBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deescalationSec',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition>
      insultsCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'insultsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition>
      insultsCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'insultsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition>
      insultsCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'insultsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition>
      insultsCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'insultsCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition> peaksEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peaks',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition> peaksGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'peaks',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition> peaksLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'peaks',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterFilterCondition> peaksBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'peaks',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyStatsQueryObject
    on QueryBuilder<DailyStats, DailyStats, QFilterCondition> {}

extension DailyStatsQueryLinks
    on QueryBuilder<DailyStats, DailyStats, QFilterCondition> {}

extension DailyStatsQuerySortBy
    on QueryBuilder<DailyStats, DailyStats, QSortBy> {
  QueryBuilder<DailyStats, DailyStats, QAfterSortBy> sortByAvgScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgScore', Sort.asc);
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterSortBy> sortByAvgScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgScore', Sort.desc);
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterSortBy> sortByDeescalationSec() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deescalationSec', Sort.asc);
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterSortBy>
      sortByDeescalationSecDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deescalationSec', Sort.desc);
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterSortBy> sortByInsultsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insultsCount', Sort.asc);
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterSortBy> sortByInsultsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insultsCount', Sort.desc);
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterSortBy> sortByPeaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peaks', Sort.asc);
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterSortBy> sortByPeaksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peaks', Sort.desc);
    });
  }
}

extension DailyStatsQuerySortThenBy
    on QueryBuilder<DailyStats, DailyStats, QSortThenBy> {
  QueryBuilder<DailyStats, DailyStats, QAfterSortBy> thenByAvgScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgScore', Sort.asc);
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterSortBy> thenByAvgScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgScore', Sort.desc);
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterSortBy> thenByDeescalationSec() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deescalationSec', Sort.asc);
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterSortBy>
      thenByDeescalationSecDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deescalationSec', Sort.desc);
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterSortBy> thenByInsultsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insultsCount', Sort.asc);
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterSortBy> thenByInsultsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insultsCount', Sort.desc);
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterSortBy> thenByPeaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peaks', Sort.asc);
    });
  }

  QueryBuilder<DailyStats, DailyStats, QAfterSortBy> thenByPeaksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peaks', Sort.desc);
    });
  }
}

extension DailyStatsQueryWhereDistinct
    on QueryBuilder<DailyStats, DailyStats, QDistinct> {
  QueryBuilder<DailyStats, DailyStats, QDistinct> distinctByAvgScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avgScore');
    });
  }

  QueryBuilder<DailyStats, DailyStats, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<DailyStats, DailyStats, QDistinct> distinctByDeescalationSec() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deescalationSec');
    });
  }

  QueryBuilder<DailyStats, DailyStats, QDistinct> distinctByInsultsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'insultsCount');
    });
  }

  QueryBuilder<DailyStats, DailyStats, QDistinct> distinctByPeaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'peaks');
    });
  }
}

extension DailyStatsQueryProperty
    on QueryBuilder<DailyStats, DailyStats, QQueryProperty> {
  QueryBuilder<DailyStats, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyStats, double, QQueryOperations> avgScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avgScore');
    });
  }

  QueryBuilder<DailyStats, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DailyStats, int, QQueryOperations> deescalationSecProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deescalationSec');
    });
  }

  QueryBuilder<DailyStats, int, QQueryOperations> insultsCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'insultsCount');
    });
  }

  QueryBuilder<DailyStats, int, QQueryOperations> peaksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'peaks');
    });
  }
}
