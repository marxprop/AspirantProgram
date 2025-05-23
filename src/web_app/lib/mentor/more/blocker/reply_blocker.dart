import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milsat_project_app/extras/components/shared_prefs/keys.dart';
import 'package:milsat_project_app/extras/components/shared_prefs/utils.dart';
import 'package:milsat_project_app/extras/models/blocker_model.dart';
import 'package:milsat_project_app/extras/models/decoded_token.dart';
import '../../../extras/api/blockers_api.dart';
import '../../../extras/components/files.dart';

class ReplyBlocker extends ConsumerStatefulWidget {
  const ReplyBlocker({
    super.key,
    required this.title,
    required this.description,
    required this.userName,
    required this.blockerId,
    required this.time,
    required this.trackId,
    required this.comments,
    required this.mentorName,
  });

  final String title;
  final String description;
  final String userName;
  final String blockerId;
  final String time;
  final String mentorName;
  final String trackId;
  final List<BlockerCommentModel> comments;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReplyBlockerState();
}

class _ReplyBlockerState extends ConsumerState<ReplyBlocker> {
  getReplies() async {
    blockerReply ??=
        await SharedPreferencesUtil.getModel<List<BlockerCommentModel>>(
      SharedPrefKeys.blockerReply,
      (json) =>
          (json as List).map((e) => BlockerCommentModel.fromJson(e)).toList(),
    );
  }

  final textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool textFieldEmpty = true;

  @override
  void initState() {
    super.initState();
    getReplies();
    _scrollController;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(44),
        child: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            widget.title,
            style: GoogleFonts.raleway(
              color: const Color(0xFF423B43),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () => context.canPop()
                ? context.pop()
                : context.pushReplacement(MentorPageSkeleton.route,
                    extra: {"currentPage": 0}),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 24,
            ),
          ),
          elevation: 0.5,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          RichText(
            text: TextSpan(
              text: widget.userName,
              style: kSmallHeadingStyle,
              children: [
                TextSpan(
                  text: " created this blocker ",
                  style: kSmallTextStyle,
                ),
                TextSpan(
                  text: "${widget.time} days ago",
                  style: kTimeTextStyle,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                margin: const EdgeInsets.all(5),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width / 1.5),
                color: AppTheme.kAppWhiteScheme,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.userName,
                          style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF504D51),
                              height: 1.5),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Hi everyone,\n'
                      '${widget.description}',
                      style: GoogleFonts.raleway(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF504D51),
                        height: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: widget.comments.isNotEmpty
                ? ListView.builder(
                    controller: _scrollController,
                    itemCount: widget.comments.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment:
                              widget.comments[index].senderName ==
                                      widget.mentorName
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: AppTheme.kAppWhiteScheme,
                              ),
                              margin: const EdgeInsets.all(5),
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.sizeOf(context).width / 1.5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.comments[index].senderName}',
                                    style: GoogleFonts.raleway(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF504D51),
                                        height: 1.5),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Text(
                                      'Hello ${widget.userName},\n'
                                      '${widget.comments[index].message}',
                                      style: GoogleFonts.raleway(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF504D51),
                                        height: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                : const SizedBox.shrink(),
          ),
          Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: textController,
                  minLines: 1,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'value cannot be null';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        textFieldEmpty = false;
                      });
                    } else {
                      setState(() {
                        textFieldEmpty = true;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.kPurpleColor2,
                      ),
                    ),
                    hintText: 'Send feedback here......',
                    hintStyle: GoogleFonts.raleway(
                      color: const Color(
                        0xFF9A989A,
                      ),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: InkWell(
                  onTap: !textFieldEmpty
                      ? () async {
                          DecodedTokenResponse? decodedToken =
                              await SharedPreferencesUtil.getModel<
                                      DecodedTokenResponse>(
                                  SharedPrefKeys.tokenResponse,
                                  (json) =>
                                      DecodedTokenResponse.fromJson(json));
                          final reply = await ref
                              .read(apiBlockerServiceProvider)
                              .replyABlocker(
                                message: textController.text,
                                userId: decodedToken!.userId!,
                                blocker: widget.blockerId,
                              );
                          widget.comments.add(reply);
                          setState(() {});
                          textController.clear();
                        }
                      : null,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: !textFieldEmpty
                          ? AppTheme.kPurpleColor2
                          : AppTheme.kPurpleColor2.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/send_button.svg',
                        height: 18,
                        width: 18,
                        // ignore: deprecated_member_use
                        color: AppTheme.kAppWhiteScheme,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
