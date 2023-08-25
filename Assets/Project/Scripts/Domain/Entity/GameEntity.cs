using UniRx;

namespace Chargezuma.Domain.Entity
{
    /// <summary>
    /// ゲームモードについての処理などを記載
    /// </summary>
    public class GameEntity : IGameEntity
    {
        public IReactiveProperty<bool> OnGameMode => GameMode;
        ReactiveProperty<bool> GameMode = default;

        /// <summary>
        /// コンストラクタ
        /// プロパティに値の代入を行う
        /// </summary>
        public GameEntity()
        {
            GameMode = new ReactiveProperty<bool>(false);
        }

        /// <summary>
        /// ゲームモードの切り替え
        /// </summary>
        void IGameEntity.GameModeChange(bool mode)
        {
            GameMode.Value = mode;
        }
    }
}
