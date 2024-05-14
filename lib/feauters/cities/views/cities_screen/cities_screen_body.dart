import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:poputi/feauters/feauters.dart';
import 'package:poputi/ui/ui.dart';
import 'package:poputi/constants/constants.dart';
import 'package:poputi/api/models/models.dart';
import 'package:poputi/models/cities_view_model.dart';
import 'package:poputi/utils/utils.dart';
import 'package:provider/provider.dart';

class CitiesScreenBodyWidget extends StatefulWidget {
  final City? city;
  final Function(City) didReturnCity;

  const CitiesScreenBodyWidget({
    Key? key,
    this.city,
    required this.didReturnCity,
  }) : super(key: key);

  @override
  State<CitiesScreenBodyWidget> createState() => _CityScreenBodyState();
}

class _CityScreenBodyState extends State<CitiesScreenBodyWidget> {
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();

  final _scrollController = ScrollController();
  final _pagination = Pagination(
    number: 1,
    size: 100,
  );

  late CitiesViewModel _citiesViewModel;

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _pagination.number += 1;
          _citiesViewModel.getCityList(
            _pagination,
            _textEditingController.text,
          );
        });
      }
    });

    _textEditingController.text = widget.city?.name ?? '';
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _citiesViewModel = Provider.of<CitiesViewModel>(
      context,
      listen: true,
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: HexColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0.0,
        titleSpacing: 0.0,
        automaticallyImplyLeading: true,
        title:

            /// SEARCH INPUT
            Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: InputWidget(
            textEditingController: _textEditingController,
            focusNode: _focusNode,
            placeholder: Titles.search,
            isRequiredField: false,
            onChanged: (text) => _onSearchTextChange(),
            onFieldSubmitted: () => FocusScope.of(context).unfocus(),
          ),
        ),
      ),
      body: SizedBox.expand(
        child: Container(
          color: HexColors.white,
          child: InkWell(
            child: Stack(children: [
              /// CITY LIST VIEW
              _isSearching
                  ? Container()
                  : CitiesListView(
                      scrollController: _scrollController,
                      cities: _citiesViewModel.cities,
                      onTap: (index) => _citiesViewModel.selectCity(
                          index,
                          (city) => {
                                widget.didReturnCity(city),
                                Navigator.pop(context),
                              }),
                    ),

              /// NO RESULT TEXT
              _citiesViewModel.loadingStatus == LoadingStatus.searching
                  ? Container()
                  : _isSearching
                      ? Container()
                      : _citiesViewModel.cities.isEmpty
                          ? const NoResultsWidget()
                          : Container(),

              /// INDICATOR
              _isSearching ||
                      _citiesViewModel.loadingStatus == LoadingStatus.searching
                  ? const Center(child: IndicatorWidget())
                  : Container(),
            ]),
          ),
        ),
      ),
    );
  }

  void _onSearchTextChange() {
    setState(() => _isSearching = true);

    EasyDebounce.debounce('city_debouncer', const Duration(milliseconds: 500),
        () async {
      _pagination.number = 1;
      _citiesViewModel
          .getCityList(
            _pagination,
            _textEditingController.text,
          )
          .then((value) => setState(() => _isSearching = false));
    });
  }
}
