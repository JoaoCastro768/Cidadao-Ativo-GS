import 'package:flutter/material.dart';
import '../models/issue.dart';
import '../theme/app_theme.dart';

IconData categoryIcon(String category) {
  switch (category) {
    case 'Iluminação':
      return Icons.lightbulb_outline;
    case 'Pavimentação':
      return Icons.construction_outlined;
    case 'Limpeza':
      return Icons.cleaning_services_outlined;
    case 'Acessibilidade':
      return Icons.accessible_outlined;
    case 'Água e esgoto':
      return Icons.water_drop_outlined;
    default:
      return Icons.place_outlined;
  }
}

class IssueCard extends StatelessWidget {
  final Issue issue;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;

  const IssueCard({
    super.key,
    required this.issue,
    required this.onTap,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.mint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(categoryIcon(issue.category), color: AppTheme.forest),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(issue.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 5),
                      Text('${issue.category} · ${issue.neighborhood}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey.shade700)),
                      const SizedBox(height: 10),
                      Row(children: [
                        Icon(
                            issue.isResolved
                                ? Icons.check_circle_outline
                                : Icons.schedule,
                            size: 15,
                            color: issue.isResolved
                                ? AppTheme.forest
                                : Colors.orange.shade800),
                        const SizedBox(width: 4),
                        Text(issue.isResolved ? 'Concluído localmente' : 'Registrado',
                            style: const TextStyle(fontSize: 12)),
                      ]),
                    ],
                  ),
                ),
                if (onFavorite != null)
                  IconButton(
                    tooltip: issue.isFavorite ? 'Remover favorito' : 'Favoritar',
                    onPressed: onFavorite,
                    icon: Icon(issue.isFavorite
                        ? Icons.bookmark
                        : Icons.bookmark_outline),
                    color: AppTheme.forest,
                  )
                else
                  const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      );
}
