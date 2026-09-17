import 'package:dsd/blank_page/appbar.dart';
import 'package:dsd/shared/api_provider.dart';
import 'package:dsd/shared/app_strings.dart';
import 'package:dsd/style_theme.dart';
import 'package:flutter/material.dart';

class TechnicianPage extends StatefulWidget {
  const TechnicianPage({super.key, this.fetch});

  final Future<dynamic> Function(Map<String, dynamic> body)? fetch;

  @override
  State<TechnicianPage> createState() => _TechnicianPageState();
}

class _TechnicianPageState extends State<TechnicianPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  List<Map<String, dynamic>> _technicians = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  bool _hasError = false;
  static const _pageSize = 10;
  bool _isLoadingMore = false;
  bool _hasMore = false;
  bool _loadMoreError = false;
  int _nextSkip = 0;
  String _searchedFirstName = '';
  String _searchedLastName = '';

  bool get _hasSearchQuery =>
      _firstNameController.text.trim().isNotEmpty &&
      _lastNameController.text.trim().isNotEmpty;

  Future<void> _searchTechnicians() async {
    if (_isLoading || _isLoadingMore || !_hasSearchQuery) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _hasError = false;
      _loadMoreError = false;
      _hasMore = false;
      _nextSkip = 0;
      _searchedFirstName = _firstNameController.text.trim();
      _searchedLastName = _lastNameController.text.trim();
      _technicians = [];
    });
    await _fetchPage(loadMore: false);
  }

  Future<void> _loadMore() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;
    setState(() {
      _isLoadingMore = true;
      _loadMoreError = false;
    });
    await _fetchPage(loadMore: true);
  }

  Future<void> _fetchPage({required bool loadMore}) async {
    try {
      final body = <String, dynamic>{
        'firstName': _searchedFirstName,
        'lastName': _searchedLastName,
        'skip': _nextSkip,
        'limit': _pageSize,
      };
      final result = await (widget.fetch != null
              ? widget.fetch!(body)
              : postapi('${dsd_server}m/Technician/read', body))
          .timeout(const Duration(seconds: 30));
      if (!mounted) return;
      if (result is! Map || result['status'] != 'S') {
        throw const FormatException('Search failed');
      }
      final data = result['objectData'];
      if (data != null && (data is! List || data.any((item) => item is! Map))) {
        throw const FormatException('Invalid search results');
      }
      final page =
          (data as List? ?? [])
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList();
      setState(() {
        _technicians = [..._technicians, ...page];
        _nextSkip += page.length;
        _hasMore = page.length >= _pageSize;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        if (loadMore) {
          _loadMoreError = true;
        } else {
          _hasError = true;
        }
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final language = AppStrings.of(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundMain,
      appBar: appBar(
        title: language.technicianSearchTitle,
        rightBtn: false,
        backAction: () => Navigator.pop(context),
      ),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNameField(
                      controller: _firstNameController,
                      label: language.technicianFirstNameHint,
                      action: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    _buildNameField(
                      controller: _lastNameController,
                      label: language.technicianLastNameHint,
                      action: TextInputAction.search,
                    ),
                    if (!_hasSearchQuery) ...[
                      const SizedBox(height: 8),
                      Text(
                        language.technicianRequiredNames,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textgrey,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed:
                            _isLoading || _isLoadingMore || !_hasSearchQuery
                                ? null
                                : _searchTechnicians,
                        icon:
                            _isLoading
                                ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF433600),
                                  ),
                                )
                                : Image.asset(
                                  'assets/DSD/icon/icon_search.png',
                                  width: 24,
                                  height: 24,
                                  color: Colors.black,
                                ),
                        label: Text(
                          _isLoading
                              ? language.technicianSearching
                              : language.technicianSearchTitle,
                          textAlign: TextAlign.center,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.black,

                          disabledBackgroundColor: const Color(0xFFE7E8E2),
                          disabledForegroundColor: Colors.black,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_technicians.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _buildTechnicianCard(_technicians[index]),
                    childCount: _technicians.length,
                  ),
                ),
              )
            else
              SliverToBoxAdapter(child: _buildSearchStatus()),
            if (_technicians.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: Column(
                    children: [
                      Text(
                        language.technicianResultCount.replaceAll(
                          '{count}',
                          _technicians.length.toString(),
                        ),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textgrey,
                        ),
                      ),
                      if (_loadMoreError) ...[
                        const SizedBox(height: 8),
                        Text(
                          language.technicianSearchErrorHint,
                          textAlign: TextAlign.center,
                        ),
                      ],
                      if (_hasMore) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            key: const Key('technician-load-more'),
                            onPressed: _isLoadingMore ? null : _loadMore,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textDark,
                              side: const BorderSide(
                                color: AppColors.primarysecond,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child:
                                _isLoadingMore
                                    ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Text(
                                      language.technicianLoadMore.replaceAll(
                                        '{count}',
                                        _pageSize.toString(),
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField({
    required TextEditingController controller,
    required String label,
    required TextInputAction action,
  }) {
    return TextField(
      controller: controller,
      enabled: !_isLoading && !_isLoadingMore,
      onChanged: (_) => setState(() {}),
      textInputAction: action,
      onSubmitted:
          action == TextInputAction.search ? (_) => _searchTechnicians() : null,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10),
          child: const Icon(
            Icons.person_outline_rounded,
            size: 24,
            color: AppColors.textgrey,
          ),
        ),
        hintText: label,
        hintStyle: const TextStyle(color: AppColors.textDark),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSearchStatus() {
    final language = AppStrings.of(context);
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!_hasSearched) return const SizedBox.shrink();
    final hasError = _hasError;
    final title =
        hasError
            ? language.technicianSearchFailed
            : language.technicianNotFound;
    final hint =
        hasError
            ? language.technicianSearchErrorHint
            : language.technicianNotFoundHint;
    return Center(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: Color(0xFFFDECEC),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasError
                    ? Icons.wifi_off_rounded
                    : Icons.person_search_outlined,
                size: 48,
                color: const Color(0xFFB54848),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF292D32),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Color(0xFF65675F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicianImage(String? imageUrl) {
    final url = imageUrl?.trim() ?? '';
    Widget fallback() =>
        Image.asset('assets/DSD/imgs/logo_app.png', fit: BoxFit.contain);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 64,
        height: 64,
        child: ColoredBox(
          color: Colors.white,
          child:
              url.isEmpty
                  ? fallback()
                  : Image.network(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => fallback(),
                    loadingBuilder:
                        (context, child, progress) =>
                            progress == null ? child : fallback(),
                  ),
        ),
      ),
    );
  }

  Widget _buildTechnicianCard(Map<String, dynamic> item) {
    final language = AppStrings.of(context);
    final name = [item['prefixName'], item['firstName'], item['lastName']]
        .map((value) => value?.toString().trim() ?? '')
        .where((value) => value.isNotEmpty)
        .join(' ');
    final isCertified = item['isCert'] == true;
    final foreground =
        isCertified ? const Color(0xFF2E7D32) : const Color(0xFFB54848);
    final background =
        isCertified ? const Color(0xFFE8F5E9) : const Color(0xFFFDECEC);
    final border =
        isCertified ? const Color(0xFFD4E8D6) : const Color(0xFFF1D5D5);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 4,
              child: ColoredBox(color: foreground),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 16, 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: border),
                    ),
                    child: _buildTechnicianImage(item['imageUrl']?.toString()),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isCertified) ...[
                          Text(
                            language.technicianCertifyingDepartment,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF65675F),
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                        Text(
                          name.isEmpty ? language.technicianUnnamed : name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF292D32),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: background,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                isCertified
                                    ? Icons.verified_rounded
                                    : Icons.info_outline,
                                size: 16,
                                color: foreground,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  isCertified
                                      ? language.technicianCertified
                                      : language.technicianNotCertified,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: foreground,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
