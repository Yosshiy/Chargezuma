
using UniRx;

namespace Chargezuma.Domain.Usecase
{

    public interface IGameUsecase
    {
        void GameModeChange(bool value);
        IReactiveProperty<bool> GetGameMode();
    }
}
