// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insult_counter_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetInsultCounterCollection on Isar {
  IsarCollection<InsultCounter> get insultCounters => this.collection();
}

const InsultCounterSchema = CollectionSchema(
  name: r'InsultCounter',
  id: 2470488883670383096,
  properties: {
    r'count': PropertySchema(
      id: 0,
      name: r'count',
      type: IsarType.long,
    ),
    r'lastSeenAt': PropertySchema(
      id: 1,
      name: r'lastSeenAt',
      type: IsarType.dateTime,
    ),
    r'lemma': PropertySchema(
      id: 2,
      name: r'lemma',
      type: IsarType.string,
    )
  },
  estimateSize: _insultCounterEstimateSize,
  serialize: _insultCounterSerialize,
  deserialize: _insultCounterDeserialize,
  deserializeProp: _insultCounterDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _insultCounterGetId,
  getLinks: _insultCounterGetLinks,
  attach: _insultCounterAttach,
  version: '3.1.0+1',
);

int _insultCounterEstimateSize(
  InsultCounter object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.lemma.length * 3;
  return bytesCount;
}

void _insultCounterSerialize(
  InsultCounter object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.count);
  writer.writeDateTime(offsets[1], object.lastSeenAt);
  writer.writeString(offsets[2], object.lemma);
}

InsultCounter _insultCounterDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = InsultCounter();
  object.count = reader.readLong(offsets[0]);
  object.id = id;
  object.lastSeenAt = reader.readDateTime(offsets[1]);
  object.lemma = reader.readString(offsets[2]);
  return object;
}

P _insultCounterDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _insultCounterGetId(InsultCounter object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _insultCounterGetLinks(InsultCounter object) {
  return [];
}

void _insultCounterAttach(
    IsarCollection<dynamic> col, Id id, InsultCounter object) {
  object.id = id;
}

extension InsultCounterQueryWhereSort
    on QueryBuilder<InsultCounter, InsultCounter, QWhere> {
  QueryBuilder<InsultCounter, InsultCounter, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension InsultCounterQueryWhere
    on QueryBuilder<InsultCounter, InsultCounter, QWhereClause> {
  QueryBuilder<InsultCounter, InsultCounter, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<InsultCounter, InsultCounter, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterWhereClause> idBetween(
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

extension InsultCounterQueryFilter
    on QueryBuilder<InsultCounter, InsultCounter, QFilterCondition> {
  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition>
      countEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition>
      countGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition>
      countLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'count',
        value: value,
      ));
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition>
      countBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'count',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition> idBetween(
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

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition>
      lastSeenAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSeenAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition>
      lastSeenAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSeenAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition>
      lastSeenAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSeenAt',
        value: value,
      ));
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition>
      lastSeenAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSeenAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition>
      lemmaEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lemma',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition>
      lemmaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lemma',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition>
      lemmaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lemma',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition>
      lemmaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lemma',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition>
      lemmaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lemma',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition>
      lemmaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lemma',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition>
      lemmaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lemma',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition>
      lemmaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lemma',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition>
      lemmaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lemma',
        value: '',
      ));
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterFilterCondition>
      lemmaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lemma',
        value: '',
      ));
    });
  }
}

extension InsultCounterQueryObject
    on QueryBuilder<InsultCounter, InsultCounter, QFilterCondition> {}

extension InsultCounterQueryLinks
    on QueryBuilder<InsultCounter, InsultCounter, QFilterCondition> {}

extension InsultCounterQuerySortBy
    on QueryBuilder<InsultCounter, InsultCounter, QSortBy> {
  QueryBuilder<InsultCounter, InsultCounter, QAfterSortBy> sortByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.asc);
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterSortBy> sortByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.desc);
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterSortBy> sortByLastSeenAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeenAt', Sort.asc);
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterSortBy>
      sortByLastSeenAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeenAt', Sort.desc);
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterSortBy> sortByLemma() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lemma', Sort.asc);
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterSortBy> sortByLemmaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lemma', Sort.desc);
    });
  }
}

extension InsultCounterQuerySortThenBy
    on QueryBuilder<InsultCounter, InsultCounter, QSortThenBy> {
  QueryBuilder<InsultCounter, InsultCounter, QAfterSortBy> thenByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.asc);
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterSortBy> thenByCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'count', Sort.desc);
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterSortBy> thenByLastSeenAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeenAt', Sort.asc);
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterSortBy>
      thenByLastSeenAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeenAt', Sort.desc);
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterSortBy> thenByLemma() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lemma', Sort.asc);
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QAfterSortBy> thenByLemmaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lemma', Sort.desc);
    });
  }
}

extension InsultCounterQueryWhereDistinct
    on QueryBuilder<InsultCounter, InsultCounter, QDistinct> {
  QueryBuilder<InsultCounter, InsultCounter, QDistinct> distinctByCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'count');
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QDistinct> distinctByLastSeenAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSeenAt');
    });
  }

  QueryBuilder<InsultCounter, InsultCounter, QDistinct> distinctByLemma(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lemma', caseSensitive: caseSensitive);
    });
  }
}

extension InsultCounterQueryProperty
    on QueryBuilder<InsultCounter, InsultCounter, QQueryProperty> {
  QueryBuilder<InsultCounter, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<InsultCounter, int, QQueryOperations> countProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'count');
    });
  }

  QueryBuilder<InsultCounter, DateTime, QQueryOperations> lastSeenAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSeenAt');
    });
  }

  QueryBuilder<InsultCounter, String, QQueryOperations> lemmaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lemma');
    });
  }
}
