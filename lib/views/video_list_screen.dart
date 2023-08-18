import 'package:flutter/material.dart';

import '../Models/video.dart';
import '../services/api_service.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({Key? key}) : super(key: key);

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  final List<Video> _videos = [];
  bool _isLoading = false;
  String _selectedSortOption = 'Default';

  @override
  void initState() {
    super.initState();
    _fetchVideos();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchNextPage();
    }
  }

  Future<void> _fetchVideos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final newVideos = await ApiService.fetchVideos(_currentPage);
      setState(() {
        _videos.addAll(newVideos);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

    }
  }

  Future<void> _fetchNextPage() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      try {
        final newVideos = await ApiService.fetchVideos(_currentPage + 1);
        setState(() {
          _videos.clear();
          _videos.addAll(newVideos);
          _currentPage++;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      
      }
    }
  }

  Future<void> _fetchPreviousPage() async {
    if (!_isLoading && _currentPage > 1) {
      setState(() {
        _isLoading = true;
      });

      try {
        final newVideos = await ApiService.fetchVideos(_currentPage - 1);
        setState(() {
          _videos.clear();
          _videos.addAll(newVideos);
          _currentPage--;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        // Handle error, e.g., show an error message to the user
      }
    }
  }

  void _onSortOptionChanged(String? newValue) {
    setState(() {
      _selectedSortOption = newValue ?? 'Default';
      _sortVideos();
    });
  }

  void _sortVideos() {
    if (_selectedSortOption == 'Title') {
      _videos.sort((a, b) => a.title.compareTo(b.title));
    } else if (_selectedSortOption == 'Published At') {
      _videos.sort((a, b) => a.publishedAt.compareTo(b.publishedAt));
    } else {
      _videos.sort(
        (a, b) => a.id.compareTo(b.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FamPay-Assignment',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedSortOption,
                    onChanged: _onSortOptionChanged,
                    items: <String>['Default', 'Title', 'Published At']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Thumbnail')),
                    DataColumn(label: Text('Title')),
                    DataColumn(label: Text('Published At')),
                    DataColumn(label: Text('Description')),
                  ],
                  rows: _videos.map((video) {
                    return DataRow(cells: [
                      DataCell(Text(video.id.toString())),
                      DataCell(Image.network(video.thumbnailsURL)),
                      DataCell(Text(video.title)),
                      DataCell(Text(video.publishedAt.toLocal().toString())),
                      DataCell(Text(video.description)),
                    ]);
                  }).toList(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _fetchPreviousPage,
                  icon: Icon(Icons.arrow_back),
                  disabledColor: Colors.grey,
                ),
                IconButton(
                  onPressed: _fetchNextPage,
                  icon: Icon(Icons.arrow_forward),
                  disabledColor: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
