// Copyright 2017 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../models.dart';
import 'chat_section.dart';
import 'message_input.dart';

/// UI Widget that represents a single chat thread
class ChatConversation extends StatefulWidget {
  /// Indicates whether this conversation is interactive.
  ///
  /// If false, the message input will be inactive.
  final bool enabled;

  /// List of [Section]s to render
  final List<Section> sections;

  /// Title of thread
  final String title;

  /// Callback for when a new message is submitted
  final ValueChanged<String> onSubmitMessage;

  /// Callback for when the share photo button is tapped
  final VoidCallback onTapSharePhoto;

  /// Callback for when the info icon is tapped
  final VoidCallback onTapInfo;

  /// Optional [ScrollController] to be used in the [ListView]. The [ListView]
  /// is a reverse list, so the `0.0` scroll offset indicates the bottom end of
  /// the list.
  final ScrollController scrollController;

  /// Constructor
  const ChatConversation({
    Key key,
    this.enabled: true,
    @required this.sections,
    this.title,
    this.onSubmitMessage,
    this.onTapSharePhoto,
    this.onTapInfo,
    this.scrollController,
  })
      : assert(enabled != null),
        assert(sections != null),
        super(key: key);

  @override
  _ChatConversationState createState() => new _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {
  final ScrollController _scrollController = new ScrollController();

  ScrollController get effectiveScrollController =>
      widget.scrollController ?? _scrollController;

  Widget _buildTitle(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return new Text(
      widget.title ?? '(No Conversation Selected)',
      style: widget.enabled
          ? theme.textTheme.title
          : theme.textTheme.title.copyWith(color: Colors.grey[500]),
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[
      // The header section.
      new Container(
        height: 56.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: FractionalOffset.centerLeft,
        decoration: new BoxDecoration(
          border: new Border(bottom: new BorderSide(color: Colors.grey[300])),
        ),
        child: new Row(
          children: <Widget>[
            new Expanded(child: _buildTitle(context)),
            new Offstage(
              offstage: !widget.enabled,
              child: new IconButton(
                icon: new Icon(Icons.info_outline),
                onPressed: widget.onTapInfo,
              ),
            ),
          ],
        ),
      ),
      new Expanded(
        child: new Column(
          children: <Widget>[
            new Flexible(
              child: new Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new ListView(
                  controller: effectiveScrollController,
                  reverse: true,
                  shrinkWrap: true,
                  children: widget.sections.reversed
                      .map((Section section) =>
                          new ChatSection(section: section))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      new MessageInput(
        enabled: widget.enabled,
        onSubmitMessage: widget.onSubmitMessage,
        onTapSharePhoto: widget.onTapSharePhoto,
      ),
    ];

    return new Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}
