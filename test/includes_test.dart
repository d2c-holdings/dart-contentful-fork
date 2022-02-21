import 'package:test/test.dart';
import 'package:collection/collection.dart';
import 'package:contentful/includes.dart';

void main() {
  Function deepEq = const DeepCollectionEquality().equals;

  group('Includes', () {
    final linkedEntry = {
      'sys': {
        'type': 'Entry',
        'id': 'A',
      },
      'fields': {
        'title': 'title',
      },
    };

    final linkedEntry2 = {
      'sys': {
        'type': 'Entry',
        'id': 'B',
      },
      'fields': {
        'title': 'title2',
      },
    };

    final linkedEntryWithLinks = {
      'sys': {
        'type': 'Entry',
        'id': 'C',
      },
      'fields': {
        'title': 'title',
        'child': {
          'sys': {
            'type': 'Link',
            'linkType': 'Entry',
            'id': 'B',
          }
        },
        'children': [
          {
            'sys': {
              'type': 'Link',
              'linkType': 'Entry',
              'id': 'A',
            }
          },
          {
            'sys': {
              'type': 'Link',
              'linkType': 'Entry',
              'id': 'B',
            }
          },
        ]
      },
    };

    test('links should be resolved', () {
      final includes = Includes.fromJson({
        'Entry': [
          linkedEntry,
          linkedEntry2,
          linkedEntryWithLinks,
        ],
      });

      final linkingList = [
        {
          'sys': {
            'type': 'Entry',
            'id': 'B',
          },
          'fields': {
            'links': [
              {
                'sys': {'type': 'Link', 'linkType': 'Entry', 'id': 'A'}
              },
            ],
            'nestedLinks': {
              'sys': {'type': 'Link', 'linkType': 'Entry', 'id': 'C'}
            },
          },
        }
      ];

      final expectedList = [
        {
          'sys': {
            'type': 'Entry',
            'id': 'B',
          },
          'fields': {
            'links': [linkedEntry],
            'nestedLinks': {
              ...linkedEntryWithLinks,
              'fields': {
                'title': 'title',
                'child': linkedEntry2,
                'children': [linkedEntry, linkedEntry2],
              },
            }
          },
        }
      ];

      final resolvedList = includes.resolveLinks(linkingList);

      expect(deepEq(resolvedList, expectedList), true);
    });

    test('links should be resolved again', () {
      final includes = Includes.fromJson({
        'Entry': [
          linkedEntry,
          linkedEntry2,
          linkedEntryWithLinks,
        ],
      });

      final linkingList = [
        {
          'sys': {
            'type': 'Entry',
            'id': 'B',
          },
          'fields': {
            'links': [
              {
                'sys': {'type': 'Link', 'linkType': 'Entry', 'id': 'A'}
              },
            ],
            'nestedLinks': {
              'sys': {'type': 'Link', 'linkType': 'Entry', 'id': 'C'}
            },
          },
        }
      ];

      final expectedList = [
        {
          'sys': {
            'type': 'Entry',
            'id': 'B',
          },
          'fields': {
            'links': [linkedEntry],
            'nestedLinks': {
              ...linkedEntryWithLinks,
              'fields': {
                'title': 'title',
                'child': linkedEntry2,
                'children': [linkedEntry, linkedEntry2],
              },
            }
          },
        }
      ];

      final resolvedList = includes.resolveLinks(linkingList);

      expect(deepEq(resolvedList, expectedList), true);
    });

    test('list of strings should be preserved', () {
      final includes = Includes.fromJson({});

      final linkingList = [
        {
          'sys': {
            'type': 'Entry',
            'id': 'B',
          },
          'fields': {
            'stringlist': ['str1', 'str2'],
          },
        }
      ];

      final expectedList = [
        {
          'sys': {
            'type': 'Entry',
            'id': 'B',
          },
          'fields': {
            'stringlist': ['str1', 'str2'],
          },
        }
      ];

      final resolvedList = includes.resolveLinks(linkingList);

      expect(deepEq(resolvedList, expectedList), true);
    });

    test('rich text with links should be resolved', () {
      final includes = Includes.fromJson({
        'Entry': [
          linkedEntry,
        ],
      });

      final linkingList = [
        {
          'sys': {
            'type': 'Entry',
            'id': 'B',
          },
          'fields': {
            'body': {
              'nodeType': 'document',
              'data': {},
              'content': [
                {
                  'nodeType': 'paragraph',
                  'content': [
                    {
                      'nodeType': 'text',
                      'value': 'Here is some content',
                      'marks': [],
                      'data': {}
                    }
                  ],
                  'data': {}
                },
                {
                  'nodeType': 'paragraph',
                  'content': [
                    {
                      'nodeType': 'text',
                      'value': 'Here is some bold content',
                      'marks': [
                        {'type': 'bold'}
                      ],
                      'data': {}
                    }
                  ],
                  'data': {}
                },
                {
                  'nodeType': 'hyperlink',
                  'content': [
                    {
                      'nodeType': 'text',
                      'value': 'Here is a link',
                      'marks': [
                        {'type': 'code'}
                      ],
                      'data': {}
                    }
                  ],
                  'data': {'uri': 'https://arisechurch.com'}
                },
                {
                  'nodeType': 'embedded-asset-block',
                  'content': [],
                  'data': {
                    'target': {
                      'sys': {'id': 'A', 'type': 'Link', 'linkType': 'Asset'}
                    }
                  }
                },
                {
                  'nodeType': 'paragraph',
                  'content': [
                    {'nodeType': 'text', 'value': '', 'marks': [], 'data': {}}
                  ],
                  'data': {}
                }
              ]
            }
          },
        }
      ];

      final expectedList = [
        {
          'sys': {
            'type': 'Entry',
            'id': 'B',
          },
          'fields': {
            'body': {
              'nodeType': 'document',
              'data': {},
              'content': [
                {
                  'nodeType': 'paragraph',
                  'content': [
                    {
                      'nodeType': 'text',
                      'value': 'Here is some content',
                      'marks': [],
                      'data': {}
                    }
                  ],
                  'data': {}
                },
                {
                  'nodeType': 'paragraph',
                  'content': [
                    {
                      'nodeType': 'text',
                      'value': 'Here is some bold content',
                      'marks': [
                        {'type': 'bold'}
                      ],
                      'data': {}
                    }
                  ],
                  'data': {}
                },
                {
                  'nodeType': 'hyperlink',
                  'content': [
                    {
                      'nodeType': 'text',
                      'value': 'Here is a link',
                      'marks': [
                        {'type': 'code'}
                      ],
                      'data': {}
                    }
                  ],
                  'data': {'uri': 'https://arisechurch.com'}
                },
                {
                  'nodeType': 'embedded-asset-block',
                  'content': [],
                  'data': {'target': linkedEntry}
                },
                {
                  'nodeType': 'paragraph',
                  'content': [
                    {'nodeType': 'text', 'value': '', 'marks': [], 'data': {}}
                  ],
                  'data': {}
                }
              ]
            }
          },
        }
      ];

      final resolvedList = includes.resolveLinks(linkingList);
      expect(deepEq(resolvedList, expectedList), true);
    });
  });
}
