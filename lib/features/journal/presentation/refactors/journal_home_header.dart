import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_journal_app/core/common/app/providers/user_provider.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/features/journal/presentation/search_cubit/search_cubit.dart';
import 'package:mental_health_journal_app/features/journal/presentation/views/journal_search_delegate.dart';
import 'package:provider/provider.dart';

class JournalHomeHeader extends StatelessWidget {
  const JournalHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) {
        final user = provider.user;
        final imageIsNull = user?.profilePictureUrl == null;
        final imageIsEmpty = user?.profilePictureUrl?.isEmpty ?? false;
        final image = imageIsNull || imageIsEmpty ? null : user?.profilePictureUrl;
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ).copyWith(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colours.softGreyColor.withValues(alpha: 0.2),
                    backgroundImage: imageIsNull
                        ? null
                        : NetworkImage(
                            image!,
                          ),
                    child: imageIsNull
                        ? const Icon(
                            Icons.person,
                            color: Colours.softGreyColor,
                            size: 20,
                          )
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Hello, ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: context.theme.textTheme.bodyMedium?.color,
                          ),
                          children: [
                            TextSpan(
                              text: '${user?.name}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colours.greenColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Today is ${DateFormat('MMM d, yyyy').format(
                          DateTime.now(),
                        )}',
                        style: const TextStyle(
                          fontSize: 12,
                          // color: Colours.greenColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      await showSearch(
                        context: context,
                        delegate: JournalSearchDelegate(
                          context.read<SearchCubit>(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.search,
                      // size: 30,
                    ),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
